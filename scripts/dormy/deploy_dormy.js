// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
//npx hardhat run scripts/deploy.js --network ganache
//验证方式一
//npx hardhat flatten ./contracts/Contract.sol > ./flatten/Contract_zot_flatten.sol
//验证方式二
//npx hardhat verify --network goerli 0xdA35C2e65143262FfC2ef608Ad341821af55fb42

async function main() {

    // 用于createAsset的示例数据
    const sampleAssetInfo = {
        creation: 1617183873,
        name: "Test Asset",
        propertyPrice: "1000000"
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
        sftPrice: ethers.parseEther("1"),
        tokenAmount: 1000,
        projectedAnnualReturn: 100,
        projectedRentalYield: 10,
        rentStartDate: 1617183873
    };

    const [owner, otherAccount1,otherAccount2] = await ethers.getSigners();

    // console.log(owner,otherAccount1)

    const AccessControl = await ethers.getContractFactory("AccessControl");
    const accessControl = await AccessControl.deploy();

    // const Asset = await ethers.getContractFactory("Asset");
    // const asset = await Asset.deploy();
    const AssetManager = await ethers.getContractFactory("AssetManager");

    const assetManager = await AssetManager.deploy(accessControl.target);

    const Dormy = await ethers.getContractFactory("Dormy");
    const dormy = await Dormy.deploy(assetManager.target,accessControl.target);

    await accessControl.connect(owner).setRole(otherAccount1.address,2)
    //把资产管理的合约也设成白名单
    await accessControl.connect(owner).setRole(assetManager.target,1)

    console.log("111")

    //新建一个资产
    const tx = await assetManager.connect(owner).createAsset(
        sampleAssetInfo.name,
        sampleAssetInfo,
        sampleLocationData,
        sampleInvestmentValue
    );

    console.log("222")

    const receipt = await tx.wait();
    let assetInfo1 = await assetManager.getAssetInfo(1)

    console.log('assetInfo1:',assetInfo1.name)

    await dormy.connect(otherAccount1).mint(otherAccount1.address,1,10000)

    console.log('assetInfo1:',await dormy.getSlotInfo(1))
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
