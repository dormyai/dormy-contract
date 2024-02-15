const { time, loadFixture, } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");
const moment = require('moment');
const BigNumber = require('bignumber.js');


//npx hardhat test ./test/dormy/Property_test.js --network polygonMumbai
describe("Property", function () {

    //先部署资产合约 再部署资产管理合约 再部署3525合约 执行一个mint 方法
    async function deployDormy() {  
      
      const [owner, otherAccount1,otherAccount2] = await ethers.getSigners();

      const AccessControl = await ethers.getContractFactory("AccessControl");
      const accessControl = await AccessControl.deploy();

      console.log(accessControl.target)

      const Property = await ethers.getContractFactory("Property");
      const property = await Property.deploy(accessControl.target);

      console.log(property.target)

      return { owner, property, otherAccount1,otherAccount2};
    }
  
    describe("测试部署资产合约", function () {
      it("创建资产管理", async function () {
        await loadFixture(deployDormy)
      });
    });
  
  });
  