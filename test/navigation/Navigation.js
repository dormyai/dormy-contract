const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");
  const { ethers } = require("hardhat");
  const moment = require('moment');


  //npx hardhat test ./test/navigation/Navigation.js
  describe("Navigation", function () {
    //部署导航合约
    async function deployNavigation() {  
      
      const Test20Fact = await ethers.getContractFactory("Test20");
      const test20 = await Test20Fact.deploy();

      const [owner, otherAccount1,otherAccount2] = await ethers.getSigners();
  
      let singleDayPrice = ethers.parseUnits("0.000000000001", "ether");
      const Navigation = await ethers.getContractFactory("Navigation");

      const navigation = await Navigation.deploy(singleDayPrice,test20.target);
  
      return { navigation, owner, test20, otherAccount1,otherAccount2 };
    }
  
    describe("合约接口测试", function () {
      it("初始化导航分类", async function () {
        const { navigation, owner } = await loadFixture(deployNavigation)

        await navigation.connect(owner).addCategory("分类1")
        await navigation.connect(owner).addCategory("分类2")
        await navigation.connect(owner).addCategory("分类3")
        await navigation.connect(owner).addCategory("分类4")
        await navigation.connect(owner).addCategory("分类5")
        await navigation.connect(owner).addCategory("分类6")
        await navigation.connect(owner).addCategory("分类7")
        await navigation.connect(owner).addCategory("分类8")

        // console.log("所有导航分类",(await navigation.getAllCategories()).toString())
        // console.log("第2到4个导航分类",(await navigation.getCategoriesRange(2,4)).toString())

        expect(await navigation.getCategoryCount()).to.equals(8)

        //修改第一个
        await navigation.connect(owner).updateCategory(1,"分类2-改")

        expect((await navigation.getCategoriesRange(1,1))[0]).to.equals("分类2-改")

      });
  
      it("设置单日竞价", async function () {
            const { navigation, owner } = await loadFixture(deployNavigation)

            let singleDayPrice = ethers.parseUnits("0.000000000001", "ether");

            await navigation.connect(owner).setSingleDayPrice(singleDayPrice)

            // console.log("单日导航价格:",(await navigation.singleDayPrice()).toString())

            expect(await navigation.singleDayPrice()).to.equals(singleDayPrice)

            singleDayPrice = ethers.parseUnits("0.000000000002", "ether");

            await navigation.connect(owner).setSingleDayPrice(singleDayPrice)

            expect(await navigation.singleDayPrice()).to.equals(singleDayPrice)
       });

       it("Mint NFT", async function () {
            const { navigation, owner } = await loadFixture(deployNavigation)

            await navigation.connect(owner).addNav("title","url","icon","description")
            await navigation.connect(owner).addNav("title","url","icon","description")
            await navigation.connect(owner).addNav("title","url","icon","description")
            await navigation.connect(owner).addNav("title","url","icon","description")
            await navigation.connect(owner).addNav("title","url","icon","description")

            expect(await navigation.getNavCount(owner.address)).to.equals(5)
            
        });

        it("给自己的NFT上架广告位", async function () {
            const { navigation, test20, owner } = await loadFixture(deployNavigation)
            //设置分类
            await navigation.connect(owner).addCategory("分类1")
            await navigation.connect(owner).addCategory("分类2")
            await navigation.connect(owner).addCategory("分类3")
            await navigation.connect(owner).addCategory("分类4")
            await navigation.connect(owner).addCategory("分类5")
            await navigation.connect(owner).addCategory("分类6")
            await navigation.connect(owner).addCategory("分类7")
            await navigation.connect(owner).addCategory("分类8")


            //设置单价
            // let singleDayPrice = ethers.parseUnits("0.01", "ether");
            // await navigation.connect(owner).setSingleDayPrice(singleDayPrice)

            //修改第一个
            await navigation.connect(owner).updateCategory(1,"分类2-改")
            expect((await navigation.getCategoriesRange(1,1))[0]).to.equals("分类2-改")

            await navigation.connect(owner).addNav("title","url","icon","description")
    
            let soltIndex = await navigation.getNavigationSlotsLength(0)
            console.log("soltIndex索引:",soltIndex)

            //授权token
            let singleDayPrice = ethers.parseUnits("0.000000000001", "ether");

            test20.connect(owner).approve(navigation.target,singleDayPrice)

            await navigation.connect(owner).listNavigationSlot(0,0,2,soltIndex)
            // console.log("获取到当前导航位，第一个分类的第一页内容:",await navigation.getNavigationSlotsTest(0))

            let nav = (await navigation.getNavigationSlots(0,1,10))[0]

            const lockExpiration = moment.unix(nav.lockExpiration.toString()).format('YYYY-MM-DD HH:mm:ss')

            console.log("获取到当前导航位，第一个分类的第一条内容:",nav,lockExpiration)
            console.log("获取到这个分类的所有导航位",await navigation.connect(owner).getAllNavigationSlotsByKey(0))

            await navigation.connect(owner).transferAllERC20Out(test20.target)

          });

    });
  
  });
  