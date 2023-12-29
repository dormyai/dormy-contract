const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");
  const { ethers } = require("hardhat");
  const moment = require('moment');
  const BigNumber = require('bignumber.js');


  //npx hardhat test ./test/dormy/DormyTest.js --network polygonMumbai
  describe("Dormy", function () {

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

    //先部署资产合约 再部署资产管理合约 再部署3525合约 执行一个mint 方法
    async function deployDormy() {  
      
      const [owner, otherAccount1,otherAccount2] = await ethers.getSigners();

      const Test20 = await ethers.getContractFactory("Test20");
      const test20 = await Test20.deploy();

      const AccessControl = await ethers.getContractFactory("AccessControl");
      const accessControl = await AccessControl.deploy();

      // const Property = await ethers.getContractFactory("Property");
      // const property = await Property.deploy();
      const PropertyManager = await ethers.getContractFactory("PropertyManager");

      const propertyManager = await PropertyManager.deploy(accessControl.target);

      const Dormy = await ethers.getContractFactory("Dormy");
      const dormy = await Dormy.deploy(propertyManager.target,accessControl.target, test20.target);

      return { accessControl,propertyManager,dormy, owner, test20, otherAccount1,otherAccount2};
    }
  
    describe("测试Mint流程", function () {
      it("创建资产管理", async function () {
        const { accessControl,propertyManager,dormy, owner, test20, otherAccount1,otherAccount2 } = await loadFixture(deployDormy)

        await accessControl.connect(owner).setRole(otherAccount1.address,2)
        //把资产管理的合约也设成白名单
        await accessControl.connect(owner).setRole(propertyManager.target,1)
        //把资Dormy的合约也设成白名单
        await accessControl.connect(owner).setRole(dormy.target,1)

        //新建一个资产
        const tx = await propertyManager.connect(owner).createProperty(
            samplePropertyInfo.propertyNumber,
            samplePropertyInfo,
            sampleLocationData,
            sampleInvestmentValue
        );

        const receipt = await tx.wait();
        let propertyInfo1 = await propertyManager.getPropertyInfo("SFT-1")

        console.log('propertyInfo1:',propertyInfo1)

        const investmentValue = await propertyManager.getPropertyInvestmentValue("SFT-1")

        console.log('property:',investmentValue.tokenPrice, ethers.formatEther(investmentValue.tokenPrice))

        await test20.connect(owner).transfer(otherAccount1,ethers.parseEther("1000000"))
        
        const balance = await test20.balanceOf(otherAccount1)

        console.log("balanceTx: ",  ethers.formatEther(balance))
      
        const approvalAmountInWei = (new BigNumber(investmentValue.tokenPrice)).times(2);

        console.log("转账金额  ",approvalAmountInWei.toString(),"  可转余额",balance);
        const approvalAmountInEther = ethers.formatEther(approvalAmountInWei.toString());
        console.log("授权金额（以 Ether 为单位）：", approvalAmountInEther);

        await test20.connect(otherAccount1).approve(dormy, approvalAmountInWei.toString());

        const allowanceAmount = await test20.allowance(otherAccount1, dormy);

        console.log("可转账金额：", allowanceAmount);

        const txMint = await dormy.connect(otherAccount1).mint(otherAccount1,1,1)

        console.log('propertyInfo1:',txMint)

        // console.log('propertyInfo1:',await dormy.getSlotInfo(1))

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
  