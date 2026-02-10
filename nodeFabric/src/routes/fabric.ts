
import { Router } from "express";
import { submitTransaction } from "../fabric/submit";
import { queryTransaction } from "../fabric/query";
import { EnrollUser } from "../fabric/register";

const router = Router();

router.post("/submit", submitTransaction);
router.post("/query", queryTransaction);
router.post("/fabric/registerIdentity", EnrollUser);

export default router;



