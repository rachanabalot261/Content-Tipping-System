const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying Content Tipping System with account:", deployer.address);
    console.log("Account balance:", (await hre.ethers.provider.getBalance(deployer.address)).toString());

    // 1. Get the Contract Factory for the TippingSystem
    // This loads the compiled bytecode and ABI of your contract.
    const TippingSystem = await hre.ethers.getContractFactory("TippingSystem");

    // 2. Deploy the contract (no constructor arguments needed)
    // The owner of the contract will be the deployer address (msg.sender in the constructor).
    const tippingSystem = await TippingSystem.deploy();

    // 3. Wait for the deployment to be confirmed on the network
    await tippingSystem.waitForDeployment();
    
    const contractAddress = await tippingSystem.getAddress();

    // 4. Log the deployed address for future interaction
    console.log("------------------------------------------");
    console.log("TippingSystem deployed to:", contractAddress);
    console.log("------------------------------------------");
}

// Execute the deployment script
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
