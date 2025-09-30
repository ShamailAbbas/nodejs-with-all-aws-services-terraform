import express from "express";
import multer from "multer";
import {
  createMedia,
  getAllMedia,
  getMediaById,
  updateMedia,
  deleteMedia
} from "../controllers/mediaController.js";

const router = express.Router();
const upload = multer();

router.post("/", upload.single("file"), createMedia);
router.get("/", getAllMedia);
router.get("/:id", getMediaById);
router.put("/:id", updateMedia);
router.delete("/:id", deleteMedia);

export default router;
