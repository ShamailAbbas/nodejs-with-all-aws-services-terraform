import express from "express";
import cors from "cors";
import mediaRoutes from "./routes/media.js";
import { connectDB } from "./db.js";
import MediaModel from "./models/Media.js";
import { config } from "./config.js";

const app = express();

// Enable CORS for all origins
app.use(cors());

// Parse JSON request bodies
app.use(express.json());

const PORT = config.Port;

const startServer = async () => {
  try {
    const sequelize = await connectDB();   // connect to DB
    const Media = MediaModel(sequelize);   // init model

    console.log("🔄 Syncing database...");
    await Media.sync({ alter: true });

    // Make Media globally available (for controllers)
    app.set("models", { Media });

    // Routes
    app.use("/media", mediaRoutes);

    app.listen(PORT, () => {
      console.log(`🚀 Server running on port ${PORT}`);
    });
  } catch (err) {
    console.error("❌ Failed to start server:", err);
    process.exit(1);
  }
};

startServer();
