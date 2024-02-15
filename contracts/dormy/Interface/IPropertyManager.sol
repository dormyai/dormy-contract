// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../Interface/IProperty.sol";

// 资产管理合约接口
interface IPropertyManager {

    event PropertyCreated(uint256 indexed propertyId, string propertyNumber, address propertyAddress);

    event PropertyStatusUpdated(string indexed propertyNumber, IProperty.PropertyStatus newStatus);

    event PropertyTenancyStatusUpdated(string indexed propertyNumber, IProperty.TenancyStatus newStatus);

    event PropertySoldQuantityUpdated(uint256 indexed soltId, uint256 soldQuantity);

    function createProperty(
        string memory propertyNumber,
        IProperty.PropertyInfo memory info,
        IProperty.PropertyLocationData memory location,
        IProperty.InvestmentValue memory investmentValue
    ) external returns (uint256);

    function getPropertyAddress(string memory propertyNumber) external view returns (address);

    function getPropertyInvestmentValue(string memory propertyNumber) external view returns (IProperty.InvestmentValue memory);

    function getPropertyInfo(string memory propertyNumber) external view returns (IProperty.PropertyInfo memory);

    function getPropertyInfoBySolt(uint256 soltId) external view returns (IProperty);

    function updatePropertyStatus(string memory propertyNumber, IProperty.PropertyStatus newStatus) external;

    function updatePropertyTenancyStatus(string memory propertyNumber, IProperty.TenancyStatus newStatus) external;

    function updatePropertySoldQuantity(uint256 soltId,uint256 soldQuantity) external;
}
