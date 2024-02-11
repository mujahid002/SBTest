const { ethers, upgrades, run } = require("hardhat");

async function main() {
  const RedWallet = await hre.ethers.getContractFactory("RedWallet");
  console.log("Deploying RedWallet Contract...");

  const redWallet = await RedWallet.deploy({ gasPrice: 30000000000 });
  await redWallet.waitForDeployment();
  const RedWalletAddress = await redWallet.getAddress();
  console.log("RedWallet Contract Address:", RedWalletAddress);
  console.log("----------------------------------------------------------");

  // Verify RedWallet
  console.log("Verifying RedWallet...");
  await run("verify:verify", {
    address: RedWalletAddress,
    constructorArguments: [],
  });
  console.log("----------------------------------------------------------");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// yarn hardhat run scripts/deploy.js --network mumbai
