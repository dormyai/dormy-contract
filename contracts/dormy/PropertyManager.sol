// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Interface/IPropertyManager.sol";
import "./Property.sol";
import "./AccessControl.sol";

contract PropertyManager is IPropertyManager{

    AccessControl public accessControl;

    uint256 public PropertyCount = 0;
    mapping(string => Property) public propertys;
    mapping(uint256 => string) public soltOfPropertys;

    event PropertyCreated(uint256 indexed PropertyId, string propertyNumber);

    constructor(address _accessControlAddress) {
        accessControl = AccessControl(_accessControlAddress);
    }

    modifier onlyAdmin() {
        require(accessControl.isAdmin(msg.sender), "PropertyManager: Not an admin");
        _;
    }

    function createProperty(
        string memory propertyNumber,
        Property.PropertyInfo memory info,
        Property.PropertyLocationData memory location,
        Property.InvestmentValue memory investmentValue
    ) external onlyAdmin override returns (uint256) {
        PropertyCount++;

        Property newProperty = new Property(address(accessControl));
        newProperty.updatePropertyInfo(info);
        newProperty.updatePropertyLocation(location);
        newProperty.updateInvestmentValue(investmentValue);

        propertys[propertyNumber] = newProperty;
        soltOfPropertys[PropertyCount] = propertyNumber;

        emit PropertyCreated(PropertyCount, propertyNumber);

        return PropertyCount;
    }

    function getPropertyAddress(string memory propertyNumber) external view returns (address) {
        return address(propertys[propertyNumber]);
    }

    function getPropertyInfo(string memory propertyNumber) external view override returns (Property.PropertyInfo memory) {
        return propertys[propertyNumber].getPropertyInfo();
    }

    function getPropertyInvestmentValue(string memory propertyNumber) external view override returns (Property.InvestmentValue memory) {
        return propertys[propertyNumber].getInvestmentValue();
    }

    function getPropertyInfoBySolt(uint256 soltId) external view override returns (Property) {
        return propertys[soltOfPropertys[soltId]];
    }

    function updatePropertyStatus(string memory propertyNumber, Property.PropertyStatus newStatus) external onlyAdmin  override {
        propertys[propertyNumber].updatePropertyStatus(newStatus);
    }

    function updatePropertyTenancyStatus(string memory propertyNumber, Property.TenancyStatus newStatus) external onlyAdmin override {
        propertys[propertyNumber].updateTenancyStatus(newStatus);
    }

    function updatePropertySoldQuantity(uint256 soltId,uint256 soldQuantity) external onlyAdmin override {

        propertys[soltOfPropertys[soltId]].getInvestmentValue().soldQuantity = soldQuantity;

        propertys[soltOfPropertys[soltId]].updateInvestmentValue(propertys[soltOfPropertys[soltId]].getInvestmentValue());
    }
}
