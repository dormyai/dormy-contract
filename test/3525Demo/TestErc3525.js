const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers")
const { expect } =  require("chai")
const { ethers } = require("hardhat")

describe("ERC3525GettingStarted", function () {
  async function deployGettingStartedFixture() {
    const [owner, otherAccount] = await ethers.getSigners();

    const GettingStarted = await ethers.getContractFactory(
      "ERC3525GettingStarted"
    );
    const gettingStarted = await GettingStarted.deploy(owner.address);

    return { gettingStarted, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      const { gettingStarted, owner } = await loadFixture(
        deployGettingStartedFixture
      );
      expect(await gettingStarted.owner()).to.equal(owner.address);
    });
  });

  describe("Mintable", function () {
    describe("Validations", function () {
      it("Should revert with not owner", async function () {
        const { gettingStarted, owner, otherAccount } = await loadFixture(
          deployGettingStartedFixture
        );
        const slot = 3525;
        const value = ethers.parseEther("9.5");
        await expect(
          gettingStarted.connect(otherAccount).mint(owner.address, slot, value)
        ).to.be.revertedWith("ERC3525GettingStarted: only owner can mint");
      });
    });

    describe("Mint", function () {
      it("Should mint to other account", async function () {
        const { gettingStarted, owner, otherAccount } = await loadFixture(
          deployGettingStartedFixture
        );
        const slot = 3525;
        const value = await ethers.parseEther("9.5");

        await gettingStarted.mint(otherAccount.address, slot, value);
        expect(await gettingStarted["balanceOf(uint256)"](1)).to.eq(value);
        expect(await gettingStarted.slotOf(1)).to.eq(slot);
        expect(await gettingStarted.ownerOf(1)).to.eq(otherAccount.address);
      });
    });
  });

  //Mint 获取tokenURI,获取slotURI,ID对ID转移，safeTransferFrom 和 onERC3525Received，setApprovalForAll，setApprovalForSlot
});
