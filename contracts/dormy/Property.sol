// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Interface/IProperty.sol";
import "./AccessControl.sol";


contract Property is IProperty {

    AccessControl public accessControl;

    PropertyInfo private info;
    PropertyLocationData private location;
    InvestmentValue private investmentValue;
    Tenancy private tenancy;
    Document private document;

    constructor(address _accessControlAddress) {
        accessControl = AccessControl(_accessControlAddress);
    }

    modifier onlyAdmin() {
        require(accessControl.isAdmin(msg.sender), "Property: Not an admin");
        _;
    }

    function getPropertyLocation() external view override returns (PropertyLocationData memory) {
        return location;
    }

    function getPropertyInfo() external view override returns (PropertyInfo memory) {
        return info;
    }

    function getInvestmentValue() external view override returns (InvestmentValue memory) {
        return investmentValue;
    }

    function getTenancy() external view override returns (Tenancy memory) {
        return tenancy;
    }

    function getPropertyDocument() external view override returns (Document memory) {
        return document;
    }

    function getPropertyStatus() view external override returns (PropertyStatus ) {
        return info.propertyStatus;
    }

    function getTenancyStatus() view external override returns (TenancyStatus) {
        return tenancy.tenancyStatus;
    }

    function updateDocument(Document memory _document) external onlyAdmin override {
        document = _document;
    }

    function updatePropertyInfo(PropertyInfo memory _info) external onlyAdmin override {
        info = _info;
    }

    function updateTenancy(Tenancy memory _tenancy) external onlyAdmin override {
        tenancy = _tenancy;
    }

    function updatePropertyLocation(PropertyLocationData memory _location) external onlyAdmin override {
        location = _location;
    }

    function updateInvestmentValue(InvestmentValue memory _investmentValue) external onlyAdmin override {
        investmentValue = _investmentValue;
    }

    function updatePropertyStatus(PropertyStatus status) external onlyAdmin override {
        info.propertyStatus = status;
    }

    function updateTenancyStatus(TenancyStatus  _tenancyStatus) external onlyAdmin override {
        tenancy.tenancyStatus = _tenancyStatus;
    }
}
