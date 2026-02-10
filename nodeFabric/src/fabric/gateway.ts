import { Gateway, Wallets } from "fabric-network";
import path from "path";
import fs from "fs";

const ccpPath = path.resolve(__dirname, "../../connection-profile.json");

export async function getGateway(identity: string) {
  const ccp = JSON.parse(fs.readFileSync(ccpPath, "utf8"));

  const walletPath = path.join(process.cwd(), "wallets");
  const wallet = await Wallets.newFileSystemWallet(walletPath);

  const gateway = new Gateway();
  await gateway.connect(ccp, {
    wallet,
    identity,
    discovery: { enabled: true, asLocalhost: true }
  });

  return gateway;
}
