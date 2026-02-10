import { Router } from "express";
import { submitTransaction } from "../fabric/submit";
import { queryTransaction } from "../fabric/query";

const router = Router();

router.post("/submit", submitTransaction);
router.post("/query", queryTransaction);

export default router;



