# Dormy-Contract

This document outlines the commands used for interacting with the Dormy contract project using Hardhat, a development environment for Ethereum software. These commands facilitate tasks such as testing, deploying, and interacting with smart contracts.

## Hardhat Commands

### General Help
- `npx hardhat help`
  - Description: Displays a list of available tasks and their descriptions in the Hardhat environment. Use this command to get an overview of what commands are available to you.

### Testing
- `npx hardhat test`
  - Description: Runs the smart contract tests located in the `test` directory of the project. This command is essential for ensuring that your contracts behave as expected before deploying them to a live network.

- `REPORT_GAS=true npx hardhat test`
  - Description: Executes the tests like the previous command but with gas reporting enabled. This environment variable setting (`REPORT_GAS=true`) instructs Hardhat to output gas usage for each test case, which is useful for optimizing gas costs.

- `npx hardhat test ./test/dormy/DormyTest.js`
  - Description: Runs a specific test file within the project. In this case, it executes the tests defined in `DormyTest.js` under the `test/dormy` directory. Use this command when you want to focus on a particular test suite.

### Local Development Network
- `npx hardhat node`
  - Description: Starts a local Ethereum network for development. This network runs entirely on your machine and is useful for deploying contracts, running tests, or performing any other task that requires an Ethereum network, without the need for real ETH or a live network.

### Deployment
- `npx hardhat run scripts/deploy.js`
  - Description: Deploys your smart contracts to the local development network using the deployment script located at `scripts/deploy.js`. This command is crucial for testing your deployment process and verifying that your contracts are deployed correctly.

- `npx hardhat run scripts/dormy/deploy_dormy.js --network blast-sepolia`
  - Description: Deploys the Dormy contract to the specified network, in this case, `blast-sepolia`. The `--network` flag allows you to specify which network configuration defined in your Hardhat config to use for the deployment. This command is used for deploying your contracts to a testnet or mainnet.

## Remarks

- Ensure you have Hardhat installed in your project and the necessary plugins configured in your `hardhat.config.js` file.
- The `REPORT_GAS=true` command requires the `hardhat-gas-reporter` plugin or a similar tool to be installed and configured in your project.
- Always test your contracts thoroughly in a local development environment before deploying them to a live network.
- Review and customize the deployment scripts (`deploy.js` and `deploy_dormy.js`) according to your project's requirements.

This guide provides a basic overview of common tasks you might perform with Hardhat in the context of the Dormy contract project. For more detailed information, refer to the [Hardhat documentation](https://hardhat.org/getting-started/).
