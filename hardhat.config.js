require("@nomicfoundation/hardhat-toolbox");

const { ACCOUNTS,INFURA_KEY,GANACHE_ACCOUNTS,DIS_DEPLOY_PK,etherscan_api_mainnet,etherscan_api_goerli,etherscan_api_op,etherscan_api_base} = require('./secrets.json');


//https://chainlist.org/
//npx hardhat verify --list-networks

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "hardhat",
  solidity: {
    compilers: [
      {
        version: "0.8.20",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      },
      {
        version: "0.8.0",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      },
      {
        version: "0.6.12",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      },
      {
        version: "0.4.18",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      }
    ]
  },
  networks: {
    mainnet: {
      url: `https://mainnet.infura.io/v3/${INFURA_KEY}`,
      accounts: ACCOUNTS
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${INFURA_KEY}`,
      accounts: ACCOUNTS
    },
    polygon: {
      url: `https://polygon-mainnet.infura.io/v3/${INFURA_KEY}`,
      accounts: ACCOUNTS
    },
    polygonMumbai: {
      url: `https://polygon-mumbai.infura.io/v3/${INFURA_KEY}`,
      accounts: ACCOUNTS
    },
    optimism: {
      url: `https://optimism-mainnet.infura.io/v3/${INFURA_KEY}`,
      accounts: ACCOUNTS
    },
    arbitrum: {
      url: `https://arbitrum-mainnet.infura.io/v3/${INFURA_KEY}`,
      accounts: ACCOUNTS
    },
    linea: {
      url: `https://linea-mainnet.infura.io/v3/${INFURA_KEY}`,
      accounts: ACCOUNTS
    },
    zora: {
      url: `https://rpc.zora.energy`,
      accounts: ACCOUNTS
    },
    dis: {
      url: `https://rpc.dischain.xyz`,
      accounts: DIS_DEPLOY_PK
    },
    blast: {
      url: `https://rpc.blastblockchain.com`,
      accounts: ACCOUNTS
    },
    // "blast-mainnet": {
    //   url: "coming end of February",
    //   accounts: [process.env.PRIVATE_KEY as string],
    //   gasPrice: 1000000000,
    // },
    // for Sepolia testnet
    "blast-sepolia": {
      url: "https://sepolia.blast.io",
      accounts: ACCOUNTS,
      gasPrice: 1000000000,
    },
    base: {
      url: `https://developer-access-mainnet.base.org`,
      accounts: ACCOUNTS
    },
    ganache: {
      url: `HTTP://127.0.0.1:8545`,
      accounts: GANACHE_ACCOUNTS
    }
  },
  etherscan: {
    apiKey: {
      mainnet: etherscan_api_mainnet,
      goerli: etherscan_api_goerli,
      optimisticEthereum: etherscan_api_op,
      base: etherscan_api_base
    },
    customChains: [
      {
        network: "zora",
        chainId: 7777777,
        urls: {
          apiURL: "https://explorer.zora.energy/api",
          browserURL: "https://explorer.zora.energy"
        }
      }
    ]
  },
};