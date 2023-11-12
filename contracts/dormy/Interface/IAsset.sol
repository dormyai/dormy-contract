// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAsset {

    // 资产状态枚举
    enum Status {
        New,       // 新建状态，尚未开始或初始化
        Upcoming,  // 即将到来，通常用于预售之前
        Active,    // 活动状态，可以进行交易或购买
        Inactive,  // 不再活动，可能已停止交易或购买
        SoldOut,   // 已售罄，不再可购买
        NotSoldOut, // 未售罄，仍然可以购买
        Disabled,  // 已禁用或停用，无法进行交易或购买
        Confirmed, // 状态已确认，可能表示审核或认证已完成
        PreSale   // 预售状态，通常在正式销售之前使用
    }

    // 资产位置信息
    struct AssetLocationData {
        string country;
        string county;
        string city;
        string state;
        string postalCode;
        string address1;
        string address2;
    }

    // 资产信息
    struct AssetInfo {
        uint64 creation; //创建时间戳
        string name;
        string propertyPrice; //资产价值
    }

    struct InvestmentValue {
        uint256 propertyPrice;  // 房屋总价
        uint256 sftPrice;       // 单个SFT的价格
        uint256 tokenAmount;    // 单个房屋的SFT总发行量
        uint256 projectedAnnualReturn;  // 年度总收益
        uint256 projectedRentalYield;   // 租金收益
        uint256 rentStartDate;          // 租期开始时间
    }

    // 文档信息
    struct Document {
        string name;
        string hash;
    }

    struct Tenancy {
        string status;  // 租赁状态，如"已出租"、"待出租"、"维护中"等
        string contractLink;  // 合同链接，用于指向租赁合同的在线位置
    }

    // 文档添加事件
    event DocumentAdded(string name, string hash, uint256 timestamp);

    // 资产位置信息更新事件
    event AssetLocationUpdated(uint256 timestamp);

    // 资产信息更新事件
    event AssetInfoUpdated(uint256 timestamp);

    // 投资价值信息更新事件
    event InvestmentValueUpdated(uint256 timestamp);

    // 向资产添加文档
    function addDocumentToAsset(Document memory document) external;

    // 更新资产信息
    function updateAssetInfo(AssetInfo memory info) external;

    // 更新资产位置信息
    function updateAssetLocation(AssetLocationData memory location) external;

    // 更新资产投资价值信息
    function updateInvestmentValue(InvestmentValue memory investmentValue) external;

    // 获取资产的文档
    function getAssetDocuments() external view returns (Document[] memory);
}
