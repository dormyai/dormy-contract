// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Interface/IRentalManagement.sol";
import "./Interface/IAccessControl.sol";
import "./Interface/IPropertyManager.sol";
import "./Interface/IERC20.sol";

contract RentalManagement is IRentalManagement {

    // 定义了一个映射，用于存储每个地址（租户）的NFT记录数组。每个地址可以有多个租赁记录。
    mapping(address => Rental[]) public rentals;
    //每个地址的索赔记录。
    mapping(address => ClaimRecord[]) public claimRecords;
    // 用于存储每个房产（通过slotId标识）的租期记录数组
    mapping(uint256 => RentPeriod[]) public rentPeriods;

    IERC20 public uToken;

    IAccessControl public accessControl;
    IPropertyManager public propertyManager;

    constructor(address _propertyManagerAddress,address _accessControlAddress,address _uToken) {
        accessControl = IAccessControl(_accessControlAddress);
        propertyManager = IPropertyManager(_propertyManagerAddress);
        uToken = IERC20(_uToken);

        //初始化一部分数据
        // RentPeriod memory newPeriod = RentPeriod({
        //     slotId: 1,
        //     totalAmount: 1000000000000000000000,
        //     startTime: 1706716800,
        //     endTime: 1709222400
        // });

        // rentPeriods[1].push(newPeriod);

        // Rental memory newRental = Rental({
        //     owner: 0xDB83330C3235489439d7EC4F238eAc31E7f614ED,
        //     slotId:1,
        //     value:1,
        //     startTime:1707746617,
        //     endTime:0,
        //     status:1
        //     });

        // rentals[0xDB83330C3235489439d7EC4F238eAc31E7f614ED].push(newRental);
    }

    modifier admin() {
        require(accessControl.isAdmin(msg.sender), "Not an admin");
        _;
    }    

    modifier trader() {
        require(accessControl.isTrader(msg.sender), "Only traders can call this");
        _;
    }

    function getRentalsLengthByAddress(address renter) public view returns (uint256) {
        return rentals[renter].length;
    }

    function getRentalsByAddress(address renter, uint256 startIndex, uint256 endIndex) public view returns (Rental[] memory) {
        require(startIndex <= endIndex, "Invalid index range");
        require(endIndex <= rentals[renter].length, "End index out of bounds");

        uint256 rangeSize = endIndex - startIndex + 1;
        Rental[] memory rentalsRange = new Rental[](rangeSize);

        for (uint256 i = 0; i < rangeSize; i++) {
            rentalsRange[i] = rentals[renter][startIndex + i];
        }

        return rentalsRange;
    }

    function getClaimRecordsLengthByAddress(address renter) public view returns (uint256) {
        return claimRecords[renter].length;
    }

    function getClaimRecordsByAddress(address renter, uint256 startIndex, uint256 endIndex) public view returns (ClaimRecord[] memory) {
        require(startIndex <= endIndex, "Invalid index range");
        require(endIndex < claimRecords[renter].length, "End index out of bounds");

        uint256 rangeSize = endIndex - startIndex + 1;
        ClaimRecord[] memory recordsRange = new ClaimRecord[](rangeSize);

        for (uint256 i = 0; i < rangeSize; i++) {
            recordsRange[i] = claimRecords[renter][startIndex + i];
        }

        return recordsRange;
    }

    function getRentPeriodsLengthBySlotId(uint256 slotId) public view returns (uint256) {
        return rentPeriods[slotId].length;
    }

    function getRentPeriodsBySlotId(uint256 slotId, uint256 startIndex, uint256 endIndex) public view returns (RentPeriod[] memory) {
        require(startIndex <= endIndex, "Invalid index range");
        require(endIndex < rentPeriods[slotId].length, "End index out of bounds");

        uint256 rangeSize = endIndex - startIndex + 1;
        RentPeriod[] memory periodsRange = new RentPeriod[](rangeSize);

        for (uint256 i = 0; i < rangeSize; i++) {
            periodsRange[i] = rentPeriods[slotId][startIndex + i];
        }

        return periodsRange;
    }

    function addRental(address renter, uint256 slotId, uint256 value, uint256 startTime, uint256 endTime) external admin {
        Rental memory newRental = Rental({
            owner: renter,
            slotId: slotId,
            value: value,
            startTime: startTime,
            endTime: endTime,
            status: 1 // 假设1表示活跃状态
        });
        rentals[renter].push(newRental);
    }

    function updateRental(address renter,uint256 index,uint256 newValue,uint256 newEndTime,uint256 newStatus) external admin {
        require(index < rentals[renter].length, "Index out of bounds");
        Rental storage rentalToUpdate = rentals[renter][index];
        rentalToUpdate.value = newValue;
        rentalToUpdate.endTime = newEndTime;
        rentalToUpdate.status = newStatus;
    }

    function addRentPeriod(uint256 slotId, uint256 totalAmount, uint256 startTime, uint256 endTime) external admin {

        require(startTime < endTime, "Invalid time period");

        // 检查是否存在时间重叠
        for (uint256 i = 0; i < rentPeriods[slotId].length; i++) {
            RentPeriod storage existingPeriod = rentPeriods[slotId][i];
            bool isOverlapping = (startTime < existingPeriod.endTime) && (endTime > existingPeriod.startTime);
            require(!isOverlapping, "Time period overlaps with an existing rent period");
        }

        require(uToken.transferFrom(msg.sender, address(this), totalAmount), "USDT transfer failed");

        RentPeriod memory newPeriod = RentPeriod({
            slotId: slotId,
            totalAmount: totalAmount,
            startTime: startTime,
            endTime: endTime
        });

        rentPeriods[slotId].push(newPeriod);

        emit RentPeriodAdded(slotId, totalAmount, startTime, endTime, msg.sender);

    }

    function queryRent(address renter, uint256 slotId, uint256 claimStartTime, uint256 claimEndTime) external view returns (uint256) {

        IProperty property = propertyManager.getPropertyInfoBySolt(slotId);

        if (address(property) == address(0x0)){
            return 0;
        }

        IProperty.InvestmentValue memory investmentValue = property.getInvestmentValue();

        RentPeriod memory rp = RentPeriod(0, 0, 0, 0);

        RentPeriod[] memory rps = rentPeriods[slotId];

        for (uint256 i = 0; i < rps.length; i++) {
            if (rps[i].startTime == claimStartTime && rps[i].endTime == claimEndTime){
                rp = rps[i];
            }
        }
        
        uint256 claimAmount = 0;

        if (rp.totalAmount == 0 || rentals[renter].length == 0){
            return claimAmount;
        }

        //计算出1份1秒多少钱
        uint256 amountPerSharePerSecond = calculateAmountPerSharePerSecond(rp, investmentValue.tokenAmount);
    
        for (uint256 i = 0; i < rentals[renter].length; i++) {
            
            if (rentals[renter][i].slotId != slotId) {
                continue;
            }

            //计算出持有的秒数
            uint256 overlapTime =  calculateOverlapSeconds(rentals[renter][i],claimStartTime,claimEndTime);

            if (overlapTime == 0){
                continue;
            }

            claimAmount += amountPerSharePerSecond * overlapTime;   
        }

        for (uint256 i = 0; i < claimRecords[renter].length; i++) {
            if (claimRecords[renter][i].slotId != slotId){
                continue;
            }
            //是该区间段内
            if (claimRecords[renter][i].startTime == claimStartTime && claimRecords[renter][i].endTime == claimEndTime) {
                claimAmount -= claimRecords[renter][i].amountClaimed;
            }
        }

        return claimAmount;
    }

    function claimRent(address renter, uint256 slotId, uint256 claimStartTime, uint256 claimEndTime) external trader {

        require(msg.sender == renter, " Insufficient Permissions ");

        IProperty property = propertyManager.getPropertyInfoBySolt(slotId);

        require(address(property) != address(0x0), " slotId not exists ");

        IProperty.InvestmentValue memory investmentValue = property.getInvestmentValue();

        RentPeriod[] memory rps = rentPeriods[slotId];

        RentPeriod memory rp = RentPeriod(0, 0, 0, 0);
        
        for (uint256 i = 0; i < rps.length; i++) {
            if (rps[i].startTime == claimStartTime && rps[i].endTime == claimEndTime){
                rp = rps[i];
            }
        }

        require(rp.totalAmount != 0," There is no rent to claim");

        //计算出1份1秒多少钱
        uint256 amountPerSharePerSecond = calculateAmountPerSharePerSecond(rp,investmentValue.tokenAmount);

        uint256 claimAmount = 0;
        for (uint256 i = 0; i < rentals[renter].length; i++) {
            
            if (rentals[renter][i].slotId != slotId) {
                continue;
            }

            //计算出持有的秒数
            uint256 overlapTime =  calculateOverlapSeconds(rentals[renter][i],claimStartTime,claimEndTime);

            if (overlapTime == 0){
                continue;
            }

            claimAmount += amountPerSharePerSecond * overlapTime;   
        }

        for (uint256 i = 0; i < claimRecords[renter].length; i++) {
            if (claimRecords[renter][i].slotId != slotId){
                continue;
            }
            //是该区间段内
            if (claimRecords[renter][i].startTime == claimStartTime && claimRecords[renter][i].endTime == claimEndTime) {
                claimAmount -= claimRecords[renter][i].amountClaimed;
            }
        }

        //新增一条记录

        ClaimRecord memory cr = ClaimRecord({
            slotId: slotId,
            amountClaimed: claimAmount,
            claimTime:block.timestamp,
            startTime:claimStartTime,
            endTime:claimEndTime,
            owner:renter
        });

        claimRecords[renter].push(cr);

        require(claimAmount > 0, "The claimable rent amount is zero");
        require(uToken.transfer(renter, claimAmount), "Transfer failed");

        emit RentClaimed(renter, slotId, claimStartTime, claimEndTime, claimAmount);
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

    function calculateOverlapSeconds(Rental memory rental, uint256 givenStartTime, uint256 givenEndTime) public view returns (uint256) {
        // 获取当前时间
        uint256 currentTime = block.timestamp;

        // 如果rental的endTime为0或大于当前时间，使用较小的值作为rentalEndTime
        uint256 rentalEndTime = rental.endTime == 0 ? currentTime : rental.endTime;

        // 如果给定的endTime大于当前时间，使用当前时间作为实际的endTime
        givenEndTime = givenEndTime > currentTime ? currentTime : givenEndTime;

        // 确保时间段有效
        if (givenStartTime >= rentalEndTime || rental.startTime >= rentalEndTime) {
            return 0; // 没有交集
        }

        // 计算交集的开始时间：两个开始时间的最大值
        uint256 overlapStartTime = rental.startTime > givenStartTime ? rental.startTime : givenStartTime;

        // 计算交集的结束时间：两个结束时间的最小值
        uint256 overlapEndTime = rentalEndTime < givenEndTime ? rentalEndTime : givenEndTime;

        // 如果开始时间大于或等于结束时间，则没有交集
        if (overlapStartTime >= overlapEndTime) {
            return 0;
        }

        // 返回交集的秒数
        return overlapEndTime - overlapStartTime;
    }

    function calculateAmountPerSharePerSecond(RentPeriod memory period, uint256 shares) public pure returns (uint256) {
        if (period.endTime <= period.startTime){
            return 0;
        }

        require(shares > 0, "Shares must be greater than 0");

        uint256 durationInSeconds = period.endTime - period.startTime;
        uint256 totalAmount = period.totalAmount;

        // 计算总金额除以总秒数，得到每秒的金额
        uint256 amountPerSecond = totalAmount / durationInSeconds;

        // 计算每秒的金额除以份数，得到每一份每一秒的金额
        uint256 amountPerSharePerSecond = amountPerSecond / shares;

        return amountPerSharePerSecond;
    }

}