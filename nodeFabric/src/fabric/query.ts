import {Request, Response} from "express";
import { getGateway } from "./gateway";

// getUsers function
export async function queryTransaction(req:Request, res: Response){
    try{
        const {channel, chaincode, function: fn, identity} = req.body;  
        const gateway = await getGateway(identity || "appuser");
        const network = await gateway.getNetwork(channel);
        const contract = network.getContract(chaincode);
        const result = await contract.evaluateTransaction(fn);

        gateway.disconnect();

        res.json({
            status:"SUCCESS",
            result:JSON.parse(result.toString())
        });
    } catch (err: any){
        res.status(500).json({
            error:err.message
        })
    }
}