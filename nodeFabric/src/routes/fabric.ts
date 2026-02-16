
import { Router } from "express";
import { submitTransaction } from "../fabric/submit";
import { queryTransaction } from "../fabric/query";
import { EnrollUser } from "../fabric/register";
import { initiateTransaction } from "../fabric/initiateTrans";

const router = Router();

router.post("/submit", submitTransaction);
router.post("/initiateTransaction", initiateTransaction);
router.post("/query", queryTransaction);
router.post("/registerIdentity", EnrollUser);

export default router;



