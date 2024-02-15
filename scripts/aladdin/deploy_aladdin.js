// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const { ethers } = require("hardhat");
//npx hardhat run scripts/deploy.js --network ganache
//验证方式一
//npx hardhat flatten ./contracts/Contract.sol > ./flatten/Contract_zot_flatten.sol
//验证方式二
//npx hardhat verify --network goerli 0xdA35C2e65143262FfC2ef608Ad341821af55fb42

// npx hardhat run scripts/aladdin/deploy_aladdin.js --network dis
async function main() {

    const [owner] = await ethers.getSigners();

    const Aladdin = await ethers.getContractFactory("Aladdin");
    const aladdin = await Aladdin.deploy(owner.address);

    await aladdin.connect(owner).setWhitelist(owner.address,true)

    console.log("TOKEN 地址:",aladdin.target)
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
