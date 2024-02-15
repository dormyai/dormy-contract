const { time, loadFixture, } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");
const moment = require('moment');
const BigNumber = require('bignumber.js');


//npx hardhat test ./test/erc404/Aladdin_test.js --network polygonMumbai
describe("Aladdin", function () {

    //先部署资产合约 再部署资产管理合约 再部署3525合约 执行一个mint 方法
    async function deploy404() {  
      
      const [owner, otherAccount1,otherAccount2] = await ethers.getSigners();

      const Aladdin = await ethers.getContractFactory("Aladdin");
      const aladdin = await Aladdin.deploy(owner.address);


      return { aladdin, owner, otherAccount1,otherAccount2};
    }
  
    describe("测试Mint流程", function () {
      it("创建资产管理", async function () {

        const { aladdin, owner, otherAccount1,otherAccount2 } = await loadFixture(deploy404)

        console.log("测试余额:",await aladdin.balanceOf(owner.address))

        await aladdin.connect(owner).setWhitelist(owner.address,true)
        // await aladdin.connect(owner).setWhitelist(otherAccount1.address,true)

        var tx = await aladdin.connect(owner).transfer(otherAccount1.address, 10000000000000000000n)

        var tx2 = await aladdin.connect(otherAccount1).transfer(otherAccount2.address, 5000000000000000000n)

        // console.log("测试余额:",await aladdin.balanceOf(owner.address))
        // console.log("测试余额:",await aladdin.balanceOf(otherAccount1.address))
        // console.log("测试余额:",await aladdin.balanceOf(otherAccount2.address))
        console.log("获取TOKEN URI:",await aladdin.tokenURI(1))
        
        // console.log(tx)

        // console.log("测试余额:",await aladdin.ownerOf(0))

      });

    });
  
  });
  