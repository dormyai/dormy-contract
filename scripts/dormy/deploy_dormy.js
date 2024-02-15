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

//npx hardhat run scripts/dormy/deploy_dormy.js --network polygonMumbai
//npx hardhat run scripts/dormy/deploy_dormy.js --network blast-sepolia
async function main() {

    // 用于createProperty的示例数据
    // const samplePropertyInfo = {
    //     creation: 1617183873,
    //     propertyNumber: "SFT-1",
    //     propertyStatus: 0,
    // };

    // const samplePropertyInfo2 = {
    //     creation: 1617183873,
    //     propertyNumber: "SFT-2",
    //     propertyStatus: 0,
    // };

    // const samplePropertyInfo3 = {
    //     creation: 1617183873,
    //     propertyNumber: "SFT-3",
    //     propertyStatus: 0,
    // };

    // const samplePropertyInfo4 = {
    //     creation: 1617183873,
    //     propertyNumber: "SFT-4",
    //     propertyStatus: 0,
    // };

    // const sampleLocationData = {
    //     country: "Country",
    //     county: "County",
    //     city: "City",
    //     state: "State",
    //     postalCode: "12345",
    //     address1: "Address 1",
    //     address2: "Address 2"
    // };

    // const sampleInvestmentValue = {
    //     propertyPrice: 100000000, //美元
    //     tokenPrice: ethers.parseEther("100"),//100U
    //     tokenAmount: 1000,
    //     soldQuantity: 0,
    //     projectedAnnualReturn: 100,
    //     projectedRentalYield: 10,
    //     rentStartDate: 1617183873,
    //     saleStartTime: 1703728800,
    //     saleEndTime: 1735351200,
    //     minPurchase: 1,
    //     maxPurchase: 10,
    //     minIncrement: 1
    // };

    const [owner] = await ethers.getSigners();
    console.log("owner:",owner.address)

    // const Test20 = await ethers.getContractFactory("Test20");
    // const test20 = await Test20.deploy();

    const AccessControl = await ethers.getContractFactory("AccessControl");
    const accessControl = await AccessControl.deploy();

    const PropertyManager = await ethers.getContractFactory("PropertyManager");
    const propertyManager = await PropertyManager.deploy(accessControl.target);

    const PropertyDeed = await ethers.getContractFactory("PropertyDeed");
    const propertyDeed = await PropertyDeed.deploy(accessControl.target);

    const RentalManagement = await ethers.getContractFactory("RentalManagement");
    // const rentalManagement = await RentalManagement.deploy(propertyManager.target,accessControl.target,test20.target);
    //马蹄TST
    // const rentalManagement = await RentalManagement.deploy(propertyManager.target,accessControl.target,"0x6e27Bf26b5b6807D16Ff86fa674F4d3229DA3774");
    // blast TST
    const rentalManagement = await RentalManagement.deploy(propertyManager.target,accessControl.target,"0x35894cBf77a17A9d9949b10EAac51B1c794411A4");

    const Dormy = await ethers.getContractFactory("Dormy");
    // const dormy = await Dormy.deploy(propertyManager.target, accessControl.target, rentalManagement.target,test20.target,propertyDeed.target);
    // const dormy = await Dormy.deploy(propertyManager.target, accessControl.target, rentalManagement.target, "0x6e27Bf26b5b6807D16Ff86fa674F4d3229DA3774",propertyDeed.target);
    const dormy = await Dormy.deploy(propertyManager.target, accessControl.target, rentalManagement.target, "0x35894cBf77a17A9d9949b10EAac51B1c794411A4",propertyDeed.target);

    await propertyDeed.setPropertyManager(propertyManager.target);
    await propertyDeed.setDormy(dormy.target);

    await accessControl.connect(owner).setRole("0x4Ffb83A8344F33453fBEbe5e126534407ceb32f5",1)
    await accessControl.connect(owner).setRole("0xB9175ABB60De2c47C8F1dAc88179dDa3Db369457",1)
    await accessControl.connect(owner).setRole("0xdb83330c3235489439d7ec4f238eac31e7f614ed",1)//边边
    await accessControl.connect(owner).setRole("0xe19311ca3d40287b0d088df368509cfc985f44bd",1)//边边
    await accessControl.connect(owner).setRole("0x0b99C69c2D7A71fb372ACf2756E315A18E5150B1",1)//白起

    // await accessControl.connect(owner).setRole(owner,0) 默认是管理员
    await accessControl.connect(owner).setRole(propertyManager.target,0)
    await accessControl.connect(owner).setRole(dormy.target,0)

    //新建一个资产
    // const tx = await propertyManager.connect(owner).createProperty(
    //     samplePropertyInfo.propertyNumber,
    //     samplePropertyInfo,
    //     sampleLocationData,
    //     sampleInvestmentValue
    // );

    // const receipt = await tx.wait();

    // const tx2 = await propertyManager.connect(owner).createProperty(
    //     samplePropertyInfo2.propertyNumber,
    //     samplePropertyInfo,
    //     sampleLocationData,
    //     sampleInvestmentValue
    // );

    // const receipt2 = await tx2.wait();

    // const tx3 = await propertyManager.connect(owner).createProperty(
    //     samplePropertyInfo3.propertyNumber,
    //     samplePropertyInfo,
    //     sampleLocationData,
    //     sampleInvestmentValue
    // );

    // const receipt3 = await tx3.wait();

    // const tx4 = await propertyManager.connect(owner).createProperty(
    //     samplePropertyInfo4.propertyNumber,
    //     samplePropertyInfo,
    //     sampleLocationData,
    //     sampleInvestmentValue
    // );

    // const receipt4 = await tx4.wait();
    // let propertyInfo1 = await propertyManager.getPropertyInfo("SFT-1")
    // console.log("propertyInfo1 :",propertyInfo1)

    // console.log("权限控制:",accessControl.target,"资产管理合约地址:",propertyManager.target,"Dormy地址:",dormy.target,"租金管理:",rentalManagement.target,"TOKEN地址:",test20.target)
    console.log("权限控制:",accessControl.target,"资产管理合约地址:",propertyManager.target,"Dormy地址:",dormy.target,"租金管理:",rentalManagement.target,"生成SVG:",propertyDeed.target)
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
