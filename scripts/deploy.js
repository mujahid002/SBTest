const { ethers, upgrades, run } = require("hardhat");

async function main() {
  const testWallet = await hre.ethers.getContractFactory("TestWallet");
  console.log("Deploying TestWallet Contract...");

  const TestWallet = await testWallet.deploy({ gasPrice: 30000000000 });
  await TestWallet.waitForDeployment();
  const TestWalletAddress = await TestWallet.getAddress();
  console.log("TestWallet Contract Address:", TestWalletAddress);
  console.log("----------------------------------------------------------");

  // Verify TestWallet
  console.log("Verifying TestWallet...");
  await run("verify:verify", {
    address: TestWalletAddress,
    constructorArguments: [],
  });
  console.log("----------------------------------------------------------");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// yarn hardhat run scripts/deploy.js --network mumbai
// https://mumbai.polygonscan.com/address/0x944fBbe3a97B29412C9a1cF8c09074253d91Ad56#code

// https://mumbai.polygonscan.com/address/0xdF2D153faFD2D6301cC53F46F0c5e6D139e7745b#code
