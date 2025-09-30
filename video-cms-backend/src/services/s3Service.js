import AWS from "aws-sdk";
import { config } from "../config.js";

const s3 = new AWS.S3({ region: config.region });

export const uploadFile = async (file) => {
  const key = `${Date.now()}-${file.originalname}`;

  const params = {
    Bucket: config.s3Bucket,
    Key: key,
    Body: file.buffer,
    ContentType: file.mimetype,
  };

  await s3.upload(params).promise();

  // Return CloudFront URL
  return `${config.cloudFrontUrl}/${encodeURIComponent(key)}`;
};

export const deleteFile = async (cloudFrontUrl) => {
  const key = decodeURIComponent(cloudFrontUrl.split("/").pop());
  const params = { Bucket: config.s3Bucket, Key: key };
  await s3.deleteObject(params).promise();
};
