// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IProperty {

    // 资产状态枚举
    enum PropertyStatus {
        New,       // 新建状态，尚未开始或初始化
        Upcoming,  // 即将到来，通常用于预售之前
        Active,    // 活动状态，可以进行交易或购买
        SoldOut,   // 已售罄，不再可购买
        Disabled   // 已禁用或停用，无法进行交易或购买
    }

    enum TenancyStatus { 
        Rented, 
        Available,
        Maintenance 
    }

    // 资产信息
    struct PropertyInfo {
        string propertyNumber; //资产编号
        uint64 creation; //创建时间戳
        PropertyStatus propertyStatus;
    }

    // 资产位置信息
    struct PropertyLocationData {
        string country;
        string county;
        string city;
        string state;
        string postalCode;
        string address1;
        string address2;
    }

    struct InvestmentValue {
        uint256 propertyPrice;  // 房屋总价
        uint256 tokenPrice;       // 单个SFT的价格
        uint256 tokenAmount;    // 单个房屋的SFT总发行量
        uint256 soldQuantity;    // 已售卖数量
        uint256 projectedAnnualReturn;  // 年度总收益
        uint256 projectedRentalYield;   // 租金收益
        uint64 rentStartDate;          // 租期开始时间
        uint64 saleStartTime; //开始售卖
        uint64 saleEndTime; //结束售卖
        uint256 minPurchase;
        uint256 maxPurchase;
        uint256 minIncrement;
    }

    // 文档信息
    struct Document {
        string name;
        string hash;
    }

    struct Tenancy {
        string contractLink;  // 合同链接，用于指向租赁合同的在线位置
        TenancyStatus tenancyStatus;
    }

    function updateDocument(Document memory document) external;

    function updatePropertyInfo(PropertyInfo memory info) external;

    function updatePropertyLocation(PropertyLocationData memory location) external;

    function updateInvestmentValue(InvestmentValue memory investmentValue) external;

    function updatePropertyStatus(PropertyStatus status) external;

    function updateTenancy(Tenancy memory _tenancy) external;

    function updateTenancyStatus(TenancyStatus _tenancyStatus) external;

    function getPropertyDocument() external view returns (Document memory);

    function getPropertyLocation() external view returns (PropertyLocationData memory);

    function getPropertyInfo() external view returns (PropertyInfo memory);

    function getInvestmentValue() external view returns (InvestmentValue memory);

    function getTenancy() external view returns (Tenancy memory);

    function getPropertyStatus() external returns (PropertyStatus) ;

    function getTenancyStatus() external returns (TenancyStatus) ;
}
