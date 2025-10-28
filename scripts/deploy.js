const hre = require("hardhat");

async function main() {
  console.log("Deploying Content Tipping System contract...");

  const Project = await hre.ethers.getContractFactory("Project");
  const project = await Project.deploy();

  await project.deployed();

  console.log("Content Tipping System deployed to:", project.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

