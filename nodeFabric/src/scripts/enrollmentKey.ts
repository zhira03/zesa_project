import FabricCAServices from 'fabric-ca-client';
import { Wallets, X509Identity } from 'fabric-network';
import fs from 'fs';
import path from 'path';

export async function registerAndEnrollUser(userId: string) {
    // 1. Load Connection Profile
    const ccpPath = path.resolve(__dirname, '..', 'connection-profile.json');
    const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

    // 2. Connect to the CA
    const caInfo = ccp.certificateAuthorities['ca.org1.example.com'];
    const ca = new FabricCAServices(caInfo.url);

    // 3. Open the wallet you created with your admin script
    const walletPath = path.join(process.cwd(), 'wallets');
    const wallet = await Wallets.newFileSystemWallet(walletPath);

    // Check if user already exists
    const userIdentity = await wallet.get(userId);
    if (userIdentity) {
        console.log(`Identity ${userId} already exists`);
        return;
    }

    // 4. Get the Admin to sign the registration request
    const adminIdentity = await wallet.get('admin');
    if (!adminIdentity) {
        throw new Error('Admin not found! Run your import script first.');
    }

    const provider = wallet.getProviderRegistry().getProvider(adminIdentity.type);
    const adminUser = await provider.getUserContext(adminIdentity, 'admin');

    // 5. Register & Enroll
    // This tells the CA: "Register this ID" and immediately "Give me the certs"
    const secret = await ca.register({
        affiliation: 'org1.department1',
        enrollmentID: userId,
        role: 'client'
    }, adminUser);

    const enrollment = await ca.enroll({
        enrollmentID: userId,
        enrollmentSecret: secret
    });

    const x509Identity: X509Identity = {
        credentials: {
            certificate: enrollment.certificate,
            privateKey: enrollment.key.toBytes(),
        },
        mspId: 'Org1MSP',
        type: 'X.509',
    };

    await wallet.put(userId, x509Identity);
    console.log(`Successfully enrolled ${userId}`);
}