// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAccessControl {
    function isAdmin(address user) external view returns (bool);
    function isTrader(address user) external view returns (bool);
}