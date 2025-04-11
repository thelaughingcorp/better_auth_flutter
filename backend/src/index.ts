import { Hono } from "hono";
import { loadEnv } from "./config";
import { auth } from "./services/auth";

loadEnv();

const app = new Hono();

app.get("/health", (c) => {
  return c.json({
    status: "ok",
  });
});

app.on(["POST", "GET"], "/api/auth/*", (c) => {
  return auth.handler(c.req.raw);
});

export default {
  port: 8000,
  fetch: app.fetch,
};
