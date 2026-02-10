import express from "express";
import fabricRoutes from "./routes/fabric";

const app = express();
app.use(express.json());

app.get("/health", (_req, res) => {
  res.json({ status: "ok", service: "fabric-service" });
});
app.use("/fabric", fabricRoutes);

export default app;
