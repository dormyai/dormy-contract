// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRentalManagement {
    struct Rental {
        address owner;
        uint256 slotId;
        uint256 value;
        uint256 startTime;
        uint256 endTime;
        uint256 status;
    }

    struct RentPeriod {
        uint256 slotId;
        uint256 totalAmount;
        uint256 startTime;
        uint256 endTime;
    }

    struct ClaimRecord {
        uint256 slotId;
        uint256 amountClaimed;
        uint256 claimTime;
        uint256 startTime;
        uint256 endTime;
        address owner;
    }

    event RentPeriodAdded(uint256 indexed slotId, uint256 totalAmount, uint256 startTime, uint256 endTime, address indexed addedBy);

    event RentClaimed(address indexed renter, uint256 slotId, uint256 claimStartTime, uint256 claimEndTime, uint256 claimAmount);

    function addRental(address renter, uint256 slotId, uint256 value, uint256 startTime, uint256 endTime) external;

    function updateRental(address renter, uint256 index, uint256 newValue, uint256 newEndTime, uint256 newStatus) external;

    function addRentPeriod(uint256 slotId, uint256 totalAmount, uint256 startTime, uint256 endTime) external;

    function claimRent(address renter, uint256 slotId, uint256 claimStartTime, uint256 claimEndTime) external;

    function queryRent(address renter, uint256 slotId, uint256 claimStartTime, uint256 claimEndTime) external returns (uint256);
}
