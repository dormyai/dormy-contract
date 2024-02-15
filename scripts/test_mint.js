const { ethers } = require("hardhat");
const BigNumber = require('bignumber.js');

const propertyManager = require('/Users/wanggaowei/git/QianJiPro/dormy-contract/artifacts/contracts/dormy/PropertyManager.sol/PropertyManager.json');
const propertyManagerAddress = "0xC6437C37394E8C9D5b2da50475218dEe4BF0C59B";
const dormy = require('/Users/wanggaowei/git/QianJiPro/dormy-contract/artifacts/contracts/dormy/Dormy.sol/Dormy.json');
const dormyAddres = "0x762161D04DffD8068B026220E104264Eb7a39Ce2"
const accessControl = require('/Users/wanggaowei/git/QianJiPro/dormy-contract/artifacts/contracts/dormy/AccessControl.sol/AccessControl.json');
const accessControlAddress = "0x7AC7ED39201bB2C2e39DBD5B196a154325f41233"
const test20 = require('/Users/wanggaowei/git/QianJiPro/dormy-contract/artifacts/contracts/test/Test20.sol/Test20.json');
const test20Address = "0x35894cBf77a17A9d9949b10EAac51B1c794411A4"
const rental = require('/Users/wanggaowei/git/QianJiPro/dormy-contract/artifacts/contracts/dormy/RentalManagement.sol/RentalManagement.json');
const rentalAddress = "0xD2Ebcc4FE11d0153D7E9300fE7521b533a2fCe34"

//0xC442D919C1609152c61Dfa52505FF2862e47caA2

//npx hardhat run scripts/test_mint.js --network polygonMumbai
//npx hardhat run scripts/test_mint.js --network blast-sepolia
async function main() {

    const [owner, otherAccount1,otherAccount2] = await ethers.getSigners();
    const dormyContract = new ethers.Contract(dormyAddres, dormy.abi, otherAccount1);
    const test20Contract = new ethers.Contract(test20Address, test20.abi, owner);
    const accessControlContract = new ethers.Contract(accessControlAddress, accessControl.abi, owner);
    const propertyManagerContract = new ethers.Contract(propertyManagerAddress, propertyManager.abi, owner);
    const rentalContract = new ethers.Contract(rentalAddress, rental.abi, owner);
    console.log("owner:",owner.address)

  
    // var ar1 = await accessControlContract.setRole("0x8dF87335426C551343198c8fD9dda5dD051C486b",1)
    // var ar1 = await accessControlContract.setRole("0x4Ffb83A8344F33453fBEbe5e126534407ceb32f5",1)
    // var ar2 = await accessControlContract.setRole("0xB9175ABB60De2c47C8F1dAc88179dDa3Db369457",1)
    // const ar3 = await accessControlContract.setRole(otherAccount1.address,1)
    // const ar4 = await accessControlContract.setRole(dormyAddres,0)
    // const ar4 = await accessControlContract.setRole(propertyManagerAddress,0)
    // const ar5 = await accessControlContract.setRole(rentalAddress,0)

    console.log("otherAccount1:",otherAccount1.address)

    // const a = await propertyManagerContract.getPropertyInfoBySolt(2)
    // console.log(a)

    const investmentValue = await propertyManagerContract.getPropertyInvestmentValue("SFT-001")
    console.log("investmentValue:",investmentValue.tokenPrice)

    // const approvalAmountInWei = (new BigNumber(investmentValue.tokenPrice)).times(2);
    const approvalAmountInWei = investmentValue.tokenPrice;

    const res = await test20Contract.connect(otherAccount1).approve(dormyAddres, approvalAmountInWei.toString());

    // await res.wait()

    const allowanceAmount = await test20Contract.allowance(otherAccount1.address, dormyAddres);

    console.log("可以转账金额:",allowanceAmount)
    
    const r = await dormyContract.mint(otherAccount1.address,1,1)

    //     console.log("r:",r)
    //先主动查询一下没有房租记录 看看是否报错

    // await test20Contract.connect(owner).approve(rentalAddress, 1000000000000000000000n);
        
    // await rentalContract.connect(owner).addRentPeriod(1,1000000000000000000000n,1706716800, 1709222400);

    // await test20Contract.connect(owner).approve(rentalAddress, 1000000000000000000000n);
        
    // await rentalContract.connect(owner).addRentPeriod(1,1000000000000000000000n,1709222400, 1711900800);

    // await test20Contract.connect(owner).approve(rentalAddress, 1000000000000000000000n);
        
    // await rentalContract.connect(owner).addRentPeriod(2,1000000000000000000000n,1706716800, 1709222400);

    // await test20Contract.connect(owner).approve(rentalAddress, 1000000000000000000000n);
        
    // await rentalContract.connect(owner).addRentPeriod(2,1000000000000000000000n,1709222400, 1711900800);

    // console.log("租金记录:", await rentalContract.getRentPeriodsLengthBySlotId(1));
    // console.log("租金记录:", await rentalContract.getRentPeriodsBySlotId(1, 0, 0));
    // console.log("租金记录:", await rentalContract.getRentalsByAddress("0xDB83330C3235489439d7EC4F238eAc31E7f614ED", 0, 0));

    // console.log("余额:",await rentalContract.connect(owner).queryRent("0xDB83330C3235489439d7EC4F238eAc31E7f614ED",1,1706716800,1709222400))

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
