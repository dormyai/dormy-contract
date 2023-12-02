// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Interface/IAssetManager.sol";
import "./Asset.sol";
import "./AccessControl.sol";

// 资产管理合约
contract AssetManager is IAssetManager{

    AccessControl public accessControl;

    uint256 public assetCount = 0;
    mapping(uint256 => IAsset) public assets;
    mapping(string => uint256) public assetIndexByName;
    

    event AssetCreated(uint256 indexed assetId, string name);

    constructor(address _accessControlAddress) {
        accessControl = AccessControl(_accessControlAddress);
    }

    modifier onlyAdmin() {
        require(accessControl.isAdmin(msg.sender), "AssetManager: Not an admin");
        _;
    }

    function createAsset(
        string memory name,
        IAsset.AssetInfo memory info,
        IAsset.AssetLocationData memory location,
        IAsset.InvestmentValue memory investmentValue
    ) external onlyAdmin override returns (uint256) {
        require(assetIndexByName[name] == 0, "Asset with this name already exists");

        assetCount++;

        IAsset newAsset = new Asset(address(accessControl));
        newAsset.updateAssetInfo(info);
        newAsset.updateAssetLocation(location);
        newAsset.updateInvestmentValue(investmentValue);

        assets[assetCount] = newAsset;
        assetIndexByName[name] = assetCount;

        emit AssetCreated(assetCount, name);

        return assetCount;
    }

    function getAssetAddress(uint256 assetId) external view override returns (address) {
        require(assetId > 0 && assetId <= assetCount, "Invalid asset ID");
        return address(assets[assetId]);
    }

    function getAssetInfo(uint256 assetId) external view override returns (IAsset.AssetInfo memory) {
        require(assetId > 0 && assetId <= assetCount, "Invalid asset ID");
        return assets[assetId].getAssetInfo();
    }

    function getAssetInfoByName(string memory name) external view override returns (IAsset.AssetInfo memory) {
        uint256 assetId = assetIndexByName[name];
        require(assetId > 0, "Asset not found");
        return assets[assetId].getAssetInfo();
    }

    function updateAssetStatus(uint256 assetId, IAsset.Status newStatus) external onlyAdmin  override {
        require(assetId > 0 && assetId <= assetCount, "Invalid asset ID");
        assets[assetId].updatePropertyStatus(newStatus);
    }

    function updateAssetTenancy(uint256 assetId, IAsset.Tenancy memory newTenancy) external onlyAdmin override {
        require(assetId > 0 && assetId <= assetCount, "Invalid asset ID");
        assets[assetId].updateTenancy(newTenancy);
    }
}
