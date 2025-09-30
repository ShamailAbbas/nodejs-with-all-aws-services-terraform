import express from "express";
import mediaRoutes from "./routes/media.js";
import { connectDB } from "./db.js";
import Media from "./models/Media.js";
import { config } from "./config.js";

const app = express();
app.use(express.json());
app.use("/media", mediaRoutes);

const PORT = config.Port;

connectDB().then(async () => {
  await Media.sync({ alter: true }); // auto-create/update table
  app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
});
