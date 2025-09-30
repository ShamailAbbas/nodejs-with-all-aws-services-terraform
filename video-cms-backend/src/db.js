import { Sequelize } from "sequelize";
import AWS from "aws-sdk";
import { config } from "./config.js";

const secretsManager = new AWS.SecretsManager({ region: config.region });

let sequelize;

export const connectDB = async () => {
  const secret = await secretsManager
    .getSecretValue({ SecretId: config.dbSecretName })
    .promise();

  const dbCreds = JSON.parse(secret.SecretString);

  sequelize = new Sequelize(dbCreds.dbname, dbCreds.username, dbCreds.password, {
    host: dbCreds.host,
    port: dbCreds.port,
    dialect: "postgres",
    logging: false,
  });

  try {
    await sequelize.authenticate();
    console.log("✅ Postgres connected!");
  } catch (err) {
    console.error("❌ DB connection error:", err);
    throw err;
  }

  return sequelize;
};

export { sequelize };
