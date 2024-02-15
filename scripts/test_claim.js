const { ethers } = require("hardhat");
const BigNumber = require('bignumber.js');

const disAirdrop = require('/Users/wanggaowei/git/QianJiPro/qianji-contract/artifacts/contracts/dis/DisAirdrop.sol/DisAirdrop.json');
const disAirdropAddress = "0x70662Eb36228dDC7C81051F00e5F5153d3F7897C";

// 权限控制: 0xF43684B95E0F7Bc1Ab638C11076Ff2F5d548cF47 资产管理合约地址: 0x069C3198bBd9a7F71cbf7e80A9c1C9d5f2Dd4052 Dormy地址: 0xe403A238d9786d0cf30d32F35A39731b26e394ac


//npx hardhat run scripts/test_mint.js --network polygonMumbai
async function main() {

    const [owner, otherAccount1,otherAccount2] = await ethers.getSigners();
    const provider = new ethers.JsonRpcProvider('https://rpc.dischain.xyz');

    const contract = new ethers.Contract(disAirdropAddress, disAirdrop.abi, provider);


    const claimFunctionData = contract.interface.encodeFunctionData("claim", ["100000000000000000000",[
			"0xcbc8ae1477af8c9b265251343911d6d7d3a869a6e14e68f1587b388026cfc511"]]);

    const transaction = {
      to: disAirdropAddress,
      from: "0xA5525CfA5e5AC5C6B346e71b8690ed75B4E3b3c6",
      data: claimFunctionData
    };
    
    provider.estimateGas(transaction)
    .then(gasEstimate => {
      console.log("Estimated Gas:", gasEstimate);
    })
    .catch(error => {
      console.error("Error estimating gas:", error);
    });

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
