// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../Property.sol";

// 资产管理合约接口
interface IPropertyManager {
    function createProperty(
        string memory name,
        Property.PropertyInfo memory info,
        Property.PropertyLocationData memory location,
        Property.InvestmentValue memory investmentValue
    ) external returns (uint256);

    function getPropertyAddress(string memory propertyNumber) external view returns (address);

    function getPropertyInvestmentValue(string memory propertyNumber) external view returns (Property.InvestmentValue memory);

    function getPropertyInfo(string memory propertyNumber) external view returns (Property.PropertyInfo memory);

    function getPropertyInfoBySolt(uint256 soltId) external view returns (Property);

    function updatePropertyStatus(string memory propertyNumber, Property.PropertyStatus newStatus) external;

    function updatePropertyTenancyStatus(string memory propertyNumber, Property.TenancyStatus newStatus) external;

    function updatePropertySoldQuantity(uint256 soltId,uint256 soldQuantity) external;
}
