import type { Request } from "express";
import type { Response } from "express";
import { getGateway } from "./gateway";

export async function submitTransaction(req: Request, res: Response) {
  try {
    console.log("Submit Transaction Endpoint hit: Starting transaction now:")
    const { channel, chaincode, function: fn, args, identity } = req.body;

    const gateway = await getGateway(identity);
    console.log(`Gateway: ${gateway}`);
    const network = await gateway.getNetwork(channel);
    const contract = network.getContract(chaincode);

    const result = await contract.submitTransaction(fn, ...args);

    gateway.disconnect();

    res.json({
      status: "SUCCESS",
      result: result.toString()
    });
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
}
