
import {Request, Response} from "express";
import { getGateway } from "./gateway";

// getUsers function
export async function queryTransaction(req: Request, res: Response) {
    try {
        console.log("Query Endpoint hit here..... Starting chaincode:");
        console.log("Request body:", req.body);
        
        const { channel, chaincode, function: fn, identity } = req.body;
        
        console.log("Getting gateway for identity:", identity || "appuser");
        const gateway = await getGateway(identity || "appuser");
        
        console.log("Getting network for channel:", channel);
        const network = await gateway.getNetwork(channel);
        
        console.log("Getting contract:", chaincode);
        const contract = network.getContract(chaincode);
        
        console.log("Evaluating transaction:", fn);
        
        // Add transaction listener for better errors
        const result = await contract.evaluateTransaction(fn);

        gateway.disconnect();

        console.log("Result:", result.toString());

        res.json({
            status: "SUCCESS",
            result: result.toString() ? JSON.parse(result.toString()) : null
        });
    } catch (err: any) {
        console.error("Full error:", err);
        console.error("Error stack:", err.stack);
        console.error("Error details:", JSON.stringify(err, null, 2));
        
        res.status(500).json({
            error: err.message,
            details: err.details || "No additional details"
        });
    }
}