import { uploadFile, deleteFile } from "../services/s3Service.js";
import { redisClient } from "../services/redisService.js";

// Helper to always get model
const getMediaModel = (req) => req.app.get("models").Media;

// CREATE / UPLOAD
export const createMedia = async (req, res) => {
  try {
    const Media = getMediaModel(req);

    if (!req.file) return res.status(400).send("No file uploaded");

    const { title, description, type } = req.body;
    const url = await uploadFile(req.file);

    const media = await Media.create({ title, description, type, url });

    await redisClient.setEx(`media:${media.id}`, 3600, JSON.stringify(media));
    res.status(201).json(media);
  } catch (err) {
    console.error(err);
    res.status(500).send("Upload failed");
  }
};

// READ ALL
export const getAllMedia = async (req, res) => {
  try {
    const Media = getMediaModel(req);
    const mediaList = await Media.findAll();
    res.json(mediaList);
  } catch (err) {
    console.error(err);
    res.status(500).send("Failed to fetch media");
  }
};

// READ ONE
export const getMediaById = async (req, res) => {
  try {
    const Media = getMediaModel(req);
    const id = req.params.id;

    const cached = await redisClient.get(`media:${id}`);
    if (cached) return res.json(JSON.parse(cached));

    const media = await Media.findByPk(id);
    if (!media) return res.status(404).send("Media not found");

    await redisClient.setEx(`media:${id}`, 3600, JSON.stringify(media));
    res.json(media);
  } catch (err) {
    console.error(err);
    res.status(500).send("Failed to fetch media");
  }
};

// UPDATE
export const updateMedia = async (req, res) => {
  try {
    const Media = getMediaModel(req);
    const id = req.params.id;
    const { title, description } = req.body;

    const media = await Media.findByPk(id);
    if (!media) return res.status(404).send("Media not found");

    media.title = title || media.title;
    media.description = description || media.description;

    await media.save();
    await redisClient.setEx(`media:${id}`, 3600, JSON.stringify(media));
    res.json(media);
  } catch (err) {
    console.error(err);
    res.status(500).send("Update failed");
  }
};

// DELETE
export const deleteMedia = async (req, res) => {
  try {
    const Media = getMediaModel(req);
    const id = req.params.id;

    const media = await Media.findByPk(id);
    if (!media) return res.status(404).send("Media not found");

    await deleteFile(media.url);     // remove from S3
    await media.destroy();           // remove DB record
    await redisClient.del(`media:${id}`); // remove cache

    res.send("Media deleted successfully");
  } catch (err) {
    console.error(err);
    res.status(500).send("Delete failed");
  }
};
