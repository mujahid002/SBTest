require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("@openzeppelin/hardhat-upgrades");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.23",
  networks: {
    mumbai: {
      url: process.env.AlCHEMY_RPC_URL,
      accounts: [process.env.PRIVATE_KEY],
      chainId: 80001,
      // gasPrice: 25000000000,
      saveDeployments: true,
    },
  },
  etherscan: {
    apiKey: {
      polygonMumbai: process.env.POLYGON_API_KEY,
    },
  },
  sourcify: {
    enabled: true,
  },
  settings: {
    optimizer: {
      enabled: true,
      runs: 1000,
    },
  },
};
