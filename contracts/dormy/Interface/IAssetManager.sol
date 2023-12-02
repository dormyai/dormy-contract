// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IAsset.sol";

// 资产管理合约接口
interface IAssetManager {
    function createAsset(
        string memory name,
        IAsset.AssetInfo memory info,
        IAsset.AssetLocationData memory location,
        IAsset.InvestmentValue memory investmentValue
    ) external returns (uint256);

    function getAssetAddress(uint256 assetId) external view returns (address);

    function getAssetInfo(uint256 assetId) external view returns (IAsset.AssetInfo memory);

    function getAssetInfoByName(string memory name) external view returns (IAsset.AssetInfo memory);

    function updateAssetStatus(uint256 assetId, IAsset.Status newStatus) external;

    function updateAssetTenancy(uint256 assetId, IAsset.Tenancy memory newTenancy) external;
}
