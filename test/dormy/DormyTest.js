const { time, loadFixture, } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");
const moment = require('moment');
const BigNumber = require('bignumber.js');


//npx hardhat test ./test/dormy/DormyTest.js
describe("Dormy", function () {

    // 用于createProperty的示例数据
    const samplePropertyInfo = {
        creation: 1617183873,
        propertyNumber: "SFT-1",
        propertyStatus: 0,
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
      propertyPrice: 100000000, //美元
      tokenPrice: ethers.parseEther("100"),//100U
      tokenAmount: 1000,
      soldQuantity: 0,
      projectedAnnualReturn: 100,
      projectedRentalYield: 10,
      rentStartDate: 1617183873,
      saleStartTime: 1703728800,
      saleEndTime: 1735351200,
      minPurchase: 1,
      maxPurchase: 10,
      minIncrement: 1
    };

    //先部署资产合约 再部署资产管理合约 再部署3525合约 执行一个mint 方法
    async function deployDormy() {  
      
      const [owner, otherAccount1,otherAccount2] = await ethers.getSigners();

      const Test20 = await ethers.getContractFactory("Test20");
      const test20 = await Test20.deploy();


      const AccessControl = await ethers.getContractFactory("AccessControl");
      const accessControl = await AccessControl.deploy();

      // console.log(accessControl.target)
      const PropertyManager = await ethers.getContractFactory("PropertyManager");
      const propertyManager = await PropertyManager.deploy(accessControl.target);

      const PropertyDeed = await ethers.getContractFactory("PropertyDeed");
      const propertyDeed = await PropertyDeed.deploy(accessControl.target);

      //租金管理
      const RentalManagement = await ethers.getContractFactory("RentalManagement");
      const rentalManagement = await RentalManagement.deploy(propertyManager.target,accessControl.target,test20.target);

      const Dormy = await ethers.getContractFactory("Dormy");
      const dormy = await Dormy.deploy(propertyManager.target, accessControl.target, rentalManagement.target, test20.target,propertyDeed.target);

      await propertyDeed.setPropertyManager(propertyManager.target);
      await propertyDeed.setDormy(dormy.target);

      return { accessControl,propertyManager,rentalManagement, dormy, owner, test20, otherAccount1,otherAccount2};
    }
  
    describe("测试Mint流程", function () {
      it("创建资产管理", async function () {
        const { accessControl,propertyManager,rentalManagement, dormy, owner, test20, otherAccount1,otherAccount2 } = await loadFixture(deployDormy)

        await accessControl.connect(owner).setRole(otherAccount1.address,1)
        //把资产管理的合约也设成白名单
        await accessControl.connect(owner).setRole(propertyManager.target,0)
        //把资Dormy的合约也设成白名单
        await accessControl.connect(owner).setRole(dormy.target,0)

        //新建一个资产
        const tx = await propertyManager.connect(owner).createProperty(
            samplePropertyInfo.propertyNumber,
            samplePropertyInfo,
            sampleLocationData,
            sampleInvestmentValue
        );

        await tx.wait();

        await test20.connect(owner).transfer(otherAccount1,ethers.parseEther("1000000"))
        
        const balance = await test20.balanceOf(otherAccount1)

        // console.log("balanceTx: ",  ethers.formatEther(balance))

        let propertyInfo1 = await propertyManager.getPropertyInfo("SFT-1")

        let investmentValue = await propertyManager.getPropertyInvestmentValue("SFT-1")

        // console.log('property:',investmentValue.soldQuantity, ethers.formatEther(investmentValue.tokenPrice))
      
        const approvalAmountInWei = (new BigNumber(investmentValue.tokenPrice)).times(2);

        // console.log("转账金额  ",approvalAmountInWei.toString(),"  可转余额",balance);
        const approvalAmountInEther = ethers.formatEther(approvalAmountInWei.toString());
        // console.log("授权金额（以 Ether 为单位）：", approvalAmountInEther);

        await test20.connect(otherAccount1).approve(dormy, approvalAmountInWei.toString());

        const allowanceAmount = await test20.allowance(otherAccount1, dormy);

        // console.log("可转账金额：", allowanceAmount);

        const txMint = await dormy.connect(otherAccount1).mint(otherAccount1,1,1);

        txMint.wait();

        propertyInfo1 = await propertyManager.getPropertyInfo("SFT-1")

        investmentValue = await propertyManager.getPropertyInvestmentValue("SFT-1")

        console.log('property:',investmentValue.soldQuantity, ethers.formatEther(investmentValue.tokenPrice))

        // console.log('propertyInfo1:',txMint)
        // console.log('获取到soltInfo:',await dormy.getSlotInfo(1))
        console.log('获取到SlotOf:',await dormy.tokenSupplyInSlot(1));
        console.log('获取到slotByIndex:',await dormy.slotByIndex(0));

        //新增一个房租记录
        //给合约授权金额
        await test20.approve(rentalManagement, 1000000000000000000000n);
        // //1号到3号
        // await rentalManagement.addRentPeriod(1,1000000000000000000000n,1704038400, 1709222400);
        await rentalManagement.addRentPeriod(1,1000000000000000000000n, 1709222400,1714492800);

        // console.log("余额：",await test20.balanceOf(rentalManagement.target),await test20.balanceOf(otherAccount1.address))

        
        // for(var i =0;i < 100000000;i++){
        // }

        //然后再claim
        // console.log("租金记录:", await rentalManagement.getRentPeriodsLengthBySlotId(1));
        // console.log("租金记录:", await rentalManagement.getRentPeriodsBySlotId(1, 0, 0));

        console.log("可以claim的金额:", await rentalManagement.queryRent(otherAccount1.address, 1,1704038400, 1709222400));
        // for(var i =0;i < 10000000000;i++){
          
        // }

        console.log("可以claim的金额:", await rentalManagement.queryRent("0xDB83330C3235489439d7EC4F238eAc31E7f614ED", 1,1706716800, 1709222400));

        await rentalManagement.connect(otherAccount1).claimRent(otherAccount1.address, 1,1706716800, 1709222400)

        console.log("余额：",await test20.balanceOf(rentalManagement.target),await test20.balanceOf(otherAccount1.address))

        // console.log("可以claim的金额:", await rentalManagement.getClaimRecordsByAddress(otherAccount1.address, 0,0));
        console.log("可以claim的金额:", await rentalManagement.queryRent(otherAccount1.address, 1,1706716800, 1709222400));

        console.log("slotURI:", await dormy.tokenURI(1));
        
        // console.log('获取到balanceOf:',await dormy.balanceOf(otherAccount1.address))

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
  