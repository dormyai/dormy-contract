// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@solvprotocol/erc-3525/ERC3525.sol";
import "./Interface/IAssetManager.sol"; // 引入资产管理合约接口文件
import "./AccessControl.sol"; // 引入资产管理合约接口文件

contract Dormy is ERC3525 {

    AccessControl public accessControl;
    IAssetManager public assetManager; // 引入资产管理合约接口

    using Strings for uint256;

    constructor(address assetManagerAddress,address _accessControlAddress) ERC3525("Dormy", "DMY", 18) {
        assetManager = IAssetManager(assetManagerAddress);
        accessControl = AccessControl(_accessControlAddress);
    }

    // 修饰符：仅交易员
    modifier onlyTrader() {
        require(accessControl.isTrader(msg.sender), "Dormy: Only traders can call this");
        _;
    }

    function mint(address to_, uint256 slot_, uint256 amount_) external onlyTrader {

        // 在mint方法中验证slot是否存在、是否在可售范围内以及是否已经售出对应份额
        // IAsset.AssetInfo memory assetInfo = assetManager.getAssetInfo(slot_);

        // require(keccak256(bytes(assetInfo.name)) == keccak256(bytes("")), "Dormy: the property does not exist");


        // 您需要在资产管理合约中实现获取slot信息的方法，并根据需要在这里调用它
        // 您可以将验证逻辑添加在这里，确保只有符合条件的情况下才执行_mint操作
        // 根据您的具体需求来实现验证逻辑

        _mint(to_, slot_, amount_);
    }

    // 获取slot的方法，通过调用资产管理合约的接口来查询
    function getSlotInfo(uint256 tokenId_) public view returns (string memory) {
        // 调用资产管理合约的接口方法来获取slot信息
        // 根据您的具体需求来实现
        // 暂时省略获取slot信息的逻辑

        return string(
            abi.encodePacked(
                '<svg width="600" height="600" xmlns="http://www.w3.org/2000/svg">',
                ' <g> <title>Layer 1</title>',
                '  <rect id="svg_1" height="600" width="600" y="0" x="0" stroke="#000" fill="#000000"/>',
                '  <text xml:space="preserve" text-anchor="start" font-family="Noto Sans JP" font-size="24" id="svg_2" y="340" x="200" stroke-width="0" stroke="#000" fill="#ffffff">TokenId: ',
                tokenId_.toString(),
                '</text>',
                '  <text xml:space="preserve" text-anchor="start" font-family="Noto Sans JP" font-size="24" id="svg_3" y="410" x="200" stroke-width="0" stroke="#000" fill="#ffffff">Balance: ',
                balanceOf(tokenId_).toString(),
                '</text>',
                '  <text xml:space="preserve" text-anchor="start" font-family="Noto Sans JP" font-size="24" id="svg_3" y="270" x="200" stroke-width="0" stroke="#000" fill="#ffffff">Slot: ',
                slotOf(tokenId_).toString(),
                '</text>',
                '  <text xml:space="preserve" text-anchor="start" font-family="Noto Sans JP" font-size="24" id="svg_4" y="160" x="150" stroke-width="0" stroke="#000" fill="#ffffff">ERC3525 GETTING STARTED</text>',
                ' </g> </svg>'
            )
        );

    }

    // function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
    //     // 获取对应tokenId的slot信息并返回
    //     // 根据您的具体需求来实现
    //     // 暂时省略获取slot信息的逻辑
    //     // 返回slot信息的字符串格式
    //     return "";
    // }
}