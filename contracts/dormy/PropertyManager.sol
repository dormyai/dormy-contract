// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Interface/IPropertyManager.sol";
import "./Interface/IAccessControl.sol";
import "./Interface/IERC20.sol";
import "./Property.sol";

contract PropertyManager is IPropertyManager{

    IAccessControl public accessControl;

    uint256 public PropertyCount = 0;
    mapping(string => IProperty) public propertys;
    mapping(uint256 => string) public soltOfPropertys;

    event PropertyCreated(uint256 indexed PropertyId, string propertyNumber);

    constructor(address _accessControlAddress) {
        accessControl = IAccessControl(_accessControlAddress);
    }

    modifier admin() {
        require(accessControl.isAdmin(msg.sender), "PropertyManager: Not an admin");
        _;
    }

    function createProperty(
        string memory propertyNumber,
        IProperty.PropertyInfo memory info,
        IProperty.PropertyLocationData memory location,
        IProperty.InvestmentValue memory investmentValue
    ) external admin override returns (uint256) {

        // 检查编号是否已经存在
        require(address(propertys[propertyNumber]) == address(0), "Property number already exists");

        PropertyCount++;
        IProperty newProperty = new Property(address(accessControl));

        newProperty.updatePropertyInfo(info);
        newProperty.updatePropertyLocation(location);
        newProperty.updateInvestmentValue(investmentValue);

        propertys[propertyNumber] = newProperty;
        soltOfPropertys[PropertyCount] = propertyNumber;

        emit PropertyCreated(PropertyCount, propertyNumber, address(newProperty));

        return PropertyCount;
    }

    function getPropertyAddress(string memory propertyNumber) external view returns (address) {
        return address(propertys[propertyNumber]);
    }

    function getPropertyInfo(string memory propertyNumber) external view override returns (IProperty.PropertyInfo memory) {
        return propertys[propertyNumber].getPropertyInfo();
    }

    function getPropertyInvestmentValue(string memory propertyNumber) external view override returns (IProperty.InvestmentValue memory) {
        return propertys[propertyNumber].getInvestmentValue();
    }

    function getPropertyInfoBySolt(uint256 soltId) external view override returns (IProperty) {
        return propertys[soltOfPropertys[soltId]];
    }

    function updatePropertyStatus(string memory propertyNumber, IProperty.PropertyStatus newStatus) external admin  override {
        propertys[propertyNumber].updatePropertyStatus(newStatus);
        emit PropertyStatusUpdated(propertyNumber, newStatus);
    }

    function updatePropertyTenancyStatus(string memory propertyNumber, IProperty.TenancyStatus newStatus) external admin override {
        propertys[propertyNumber].updateTenancyStatus(newStatus);
        emit PropertyTenancyStatusUpdated(propertyNumber, newStatus);
    }

    //可能没用 先留着
    function updatePropertySoldQuantity(uint256 soltId,uint256 soldQuantity) external admin override {

        IProperty.InvestmentValue memory investmentValue = propertys[soltOfPropertys[soltId]].getInvestmentValue();

        investmentValue.soldQuantity = soldQuantity;

        propertys[soltOfPropertys[soltId]].updateInvestmentValue(investmentValue);
    }

    receive() payable external {}

    // 提取ERC20代币余额
    function withdrawERC20(address erc20Token, uint256 amount) external admin {
        IERC20 token = IERC20(erc20Token);
        require(token.transfer(msg.sender, amount), "Transfer failed");
    }

    // 提取ETH余额
    function withdrawETH(uint256 amount) external admin {
        payable(msg.sender).transfer(amount);
    }
}
