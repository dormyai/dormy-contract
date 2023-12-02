// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Interface/IAsset.sol";
import "./AccessControl.sol";

// 资产合约
contract Asset is IAsset {

    AccessControl public accessControl;

    // 资产数据结构
    AssetInfo public info;
    AssetLocationData public location;
    InvestmentValue public investmentValue;
    Status public propertyStatus; //房产状态
    Tenancy public tenancy; //租借状态
    Document public document;
    address[] public buyers;

    constructor(address _accessControlAddress) {
        // 初始化合约
        accessControl = AccessControl(_accessControlAddress);
    }

    modifier onlyAdmin() {
        require(accessControl.isAdmin(msg.sender), "Asset: Not an admin");
        _;
    }

    function getAssetLocation()
        external
        view
        override
        returns (AssetLocationData memory)
    {
        return location;
    }

    function getAssetInfo() external view override returns (AssetInfo memory) {
        return info;
    }

    function getInvestmentValue()
        external
        view
        override
        returns (InvestmentValue memory)
    {
        return investmentValue;
    }

    function getTenancy() external view override returns (Tenancy memory) {
        return tenancy;
    }

    function getAssetDocument()
        external
        view
        override
        returns (Document memory)
    {
        return document;
    }

    function updateDocument(Document memory _document) external onlyAdmin override {
        document = _document;
    }

    function updateAssetInfo(AssetInfo memory _info) external onlyAdmin override {
        info = _info;
    }

    function updateTenancy(Tenancy memory _tenancy) external onlyAdmin override {
        tenancy = _tenancy;
    }

    function updateAssetLocation(
        AssetLocationData memory _location
    ) external onlyAdmin override {
        location = _location;
    }

    function updateInvestmentValue(
        InvestmentValue memory _investmentValue
    ) external onlyAdmin override {
        investmentValue = _investmentValue;
    }

    function updatePropertyStatus(Status _status) external onlyAdmin override {
        propertyStatus = _status;
    }
}
