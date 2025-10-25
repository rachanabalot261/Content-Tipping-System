const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contract with the account:", deployer.address);
  console.log("Account balance:", (await hre.ethers.provider.getBalance(deployer.address)).toString());

  // 1. Get the Contract Factory for TippingSystem
  const TippingSystem = await hre.ethers.getContractFactory("TippingSystem");

  // 2. Deploy the contract (no constructor arguments needed)
  const tippingSystem = await TippingSystem.deploy();

  // 3. Wait for the deployment to be confirmed on the network
  await tippingSystem.waitForDeployment();
  
  const contractAddress = await tippingSystem.getAddress();

  // 4. Log the deployed address for future interaction
  console.log("TippingSystem deployed to:", contractAddress);
}

// Execute the deployment script
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
