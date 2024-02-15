// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@solvprotocol/erc-3525/ERC3525SlotEnumerable.sol";
import "./Interface/IPropertyManager.sol";
import "./Interface/IAccessControl.sol";
import "./Interface/IRentalManagement.sol";
import "./Interface/IPropertyDeed.sol";
import "./Interface/IERC20.sol";

contract Dormy is ERC3525SlotEnumerable {

    IAccessControl public accessControl;
    IPropertyManager public propertyManager;
    IRentalManagement public rentalManagement;
    IPropertyDeed public propertyDeed;
    IERC20 public uToken;

    event MintDormy(address indexed to, uint256 indexed slot,uint256 indexed tokenId, uint256 amount);

    constructor(address propertyManagerAddress,address _accessControlAddress,address _rentalManagement,address _uToken,address _propertyDeed) ERC3525SlotEnumerable("Dormy", "DMY", 18) {
        propertyManager = IPropertyManager(propertyManagerAddress);
        accessControl = IAccessControl(_accessControlAddress);
        rentalManagement = IRentalManagement(_rentalManagement);
        propertyDeed = IPropertyDeed(_propertyDeed);
        uToken = IERC20(_uToken);
    }

    // 修饰符：仅交易员
    modifier trader() {
        require(accessControl.isTrader(msg.sender), "Only traders can call this");
        _;
    }

     // 修饰符：仅管理员
    modifier admin() {
        require(accessControl.isAdmin(msg.sender), "Only admin can call this");
        _;
    }

    function mint(address to_, uint256 slot_, uint256 amount_) external trader {

        // 在mint方法中验证slot是否存在、是否在可售范围内以及是否已经售出对应份额
        // 获取到出售价格,出售状态,总数量,剩余数量
        IProperty property = propertyManager.getPropertyInfoBySolt(slot_);

        IProperty.PropertyInfo memory info =  property.getPropertyInfo();

        require(info.propertyStatus != IProperty.PropertyStatus.Active, "Property Status Abnormal, Cannot Purchase");

        IProperty.InvestmentValue memory investmentValue = property.getInvestmentValue();

        //验证可售卖数量是否足够
        require(investmentValue.tokenAmount > investmentValue.soldQuantity + amount_,"Insufficient quantity for purchase");
        
        // 调用 USDT 合约的 transfer 函数来扣减代币
        require(uToken.transferFrom(msg.sender, address(this), investmentValue.tokenPrice * amount_), "Insufficient balance");

        propertyManager.updatePropertySoldQuantity(slot_, investmentValue.soldQuantity + amount_);

        //新增记录
        rentalManagement.addRental(msg.sender, slot_, amount_, block.timestamp, 0);

        uint256 tokenId = _mint(to_, slot_, amount_);

        emit MintDormy(to_, slot_, tokenId, amount_);
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

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return propertyDeed.tokenURI(tokenId);
    }
}
