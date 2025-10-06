import redis from "redis";
import { config } from "../config.js";

export const redisClient = redis.createClient({
  socket: { host: config.redisHost, port: config.redisPort },
});

redisClient.connect().then(() => console.log("Redis connected"));
