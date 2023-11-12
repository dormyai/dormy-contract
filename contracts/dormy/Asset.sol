// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Interface/IAsset.sol";

// 资产合约
contract Asset is IAsset {
    // 资产数据结构
    AssetInfo public info;
    AssetLocationData public location;
    InvestmentValue public investmentValue;
    Status public propertyStatus;//房产状态
    Tenancy public tenancy;//租借状态
    Document[] public documents;
    address[] public buyers;

    constructor() {
        // 初始化合约
    }

    function addDocumentToAsset(Document memory document) external override {}

    function updateAssetInfo(AssetInfo memory _info) external override {}

    function updateAssetLocation(
        AssetLocationData memory _location
    ) external override {}

    function getAssetDocuments()
        external
        view
        override
        returns (Document[] memory)
    {}

    function updateInvestmentValue(
        InvestmentValue memory investmentValue
    ) external override {}
}
