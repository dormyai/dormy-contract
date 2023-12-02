const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");
  const { ethers } = require("hardhat");
  const moment = require('moment');


  //npx hardhat test ./test/dormy/DormyTest.js --network polygonMumbai
  describe("Dormy", function () {

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

    //先部署资产合约 再部署资产管理合约 再部署3525合约 执行一个mint 方法
    async function deployDormy() {  
      
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

      return { accessControl,assetManager,dormy, owner, otherAccount1,otherAccount2};
    }
  
    describe("测试Mint流程", function () {
      it("创建资产管理", async function () {
        const { accessControl,assetManager,dormy, owner, otherAccount1,otherAccount2 } = await loadFixture(deployDormy)


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

        //获取到这个资产

        // 确认事件被触发
        // expect(receipt.events.length).to.equal(1);
        // expect(receipt.events[0].event).to.equal("AssetCreated");
        // const newAssetId = receipt.events[0].args.assetId;

        // 确认新创建的资产ID
        // expect(newAssetId).to.be.a('number');

      });

    });
  
  });
  