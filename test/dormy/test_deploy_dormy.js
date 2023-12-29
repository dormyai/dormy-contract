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

async function main() {

    // 用于createProperty的示例数据
    const samplePropertyInfo = {
        creation: 1617183873,
        propertyNumber: "SFT-1",
        propertyStatus: 0,
        propertyPrice: 100000000 //美元
    };

    const sampleLocationData = {
        country: "Country",
        county: "County",
        city: "City",
        state: "State",
        postalCode: "12345",
        address1: "Address 1",
        address2: "Address 2"
    };

    const sampleInvestmentValue = {
        propertyPrice: ethers.parseEther("1000"),
        tokenPrice: ethers.parseEther("0.00001"),
        tokenAmount: 1000,
        soldQuantity: 0,
        projectedAnnualReturn: 100,
        projectedRentalYield: 10,
        rentStartDate: 1617183873,
        saleStartTime: 1703728800,
        saleEndTime: 1735351200,
        minPurchase: 1,
        minIncrement: 10
    };

    const [owner, otherAccount2] = await ethers.getSigners();


    const Test20 = await ethers.getContractFactory("Test20");
    const test20 = await Test20.deploy();

    const AccessControl = await ethers.getContractFactory("AccessControl");
    const accessControl = await AccessControl.deploy();

    const PropertyManager = await ethers.getContractFactory("PropertyManager");

    const propertyManager = await PropertyManager.deploy(accessControl.target);

    const Dormy = await ethers.getContractFactory("Dormy");
    const dormy = await Dormy.deploy(propertyManager.target,accessControl.target, test20.target);

    await accessControl.connect(owner).setRole("0xe19311ca3d40287b0d088df368509cfc985f44bd",2)//边边
    await accessControl.connect(owner).setRole("0x0b99C69c2D7A71fb372ACf2756E315A18E5150B1",2)//白起

    await accessControl.connect(owner).setRole(owner,1)
    await accessControl.connect(owner).setRole(propertyManager.target,1)
    await accessControl.connect(owner).setRole(dormy.target,1)

    //新建一个资产
    const tx = await propertyManager.connect(owner).createProperty(
        samplePropertyInfo.propertyNumber,
        samplePropertyInfo,
        sampleLocationData,
        sampleInvestmentValue
    );

    const receipt = await tx.wait();
    let assetInfo1 = await assetManager.getAssetInfo(1)  

    log.console("资产管理合约地址:",propertyManager.target,"Dormy地址:",dormy.target)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
