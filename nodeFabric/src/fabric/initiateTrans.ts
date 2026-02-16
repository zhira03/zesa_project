import { Request, Response } from "express";
import { getGateway } from "./gateway";

export async function initiateTransaction(req: Request, res: Response) {
    try {
        console.log("Submit Transaction Endpoint hit... Starting chaincode:");
        const { channel, chaincode, function: fn, args = [], identity } = req.body;
        
        const gateway = await getGateway(identity || "appuser");
        const network = await gateway.getNetwork(channel);
        const contract = network.getContract(chaincode);
        const result = await contract.submitTransaction(fn, ...args);

        gateway.disconnect();

        res.json({
            status: "SUCCESS",
            result: result.toString() ? JSON.parse(result.toString()) : null
        });
    } catch (err: any) {
        res.status(500).json({
            status: "ERROR",
            error: err.message
        });
    }
}