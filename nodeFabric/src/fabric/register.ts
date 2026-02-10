import type { Request } from "express";
import type { Response } from "express";
import { getGateway } from "./gateway";
import { registerAndEnrollUser } from "../scripts/enrollmentKey";

export async function EnrollUser(req: Request, res: Response) {
    try{
        const {userID} = req.body;
        const result = await registerAndEnrollUser(userID);
        res.json(result);
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
}