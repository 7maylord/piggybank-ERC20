import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require('dotenv').config()

const { ALCHEMY_LISK_SEPOLIA_API_KEY_URL, ACCOUNT_PRIVATE_KEY, LISKSCOUT_API_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  networks: {
    base_sepolia: {
      url: ALCHEMY_LISK_SEPOLIA_API_KEY_URL,
      accounts: [`0x${ACCOUNT_PRIVATE_KEY}`]
    }
  },
  etherscan: {
    apiKey: LISKSCOUT_API_KEY,
  },
};

export default config;
