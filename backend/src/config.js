import dotenv from "dotenv";
dotenv.config();

export const config = {
  dbSecretName: process.env.DB_SECRET_NAME,
  region: process.env.AWS_REGION || "us-east-1",
  s3Bucket: process.env.S3_BUCKET_NAME,
  cloudFrontUrl: process.env.CLOUDFRONT_URL,
  redisHost: process.env.REDIS_HOST,
  redisPort: process.env.REDIS_PORT || 6379,
  Port: process.env.PORT || 5000,
};
