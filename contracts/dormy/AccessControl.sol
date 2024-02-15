// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Interface/IAccessControl.sol";

contract AccessControl {

    enum Role {Admin, Trader}

    mapping(address => Role) public roles;
    address[] public admins;   // 管理员地址列表
    address[] public traders;  // 交易员地址列表

    event RoleSet(address indexed user, Role role);
    event RoleRemoved(address indexed user, Role role);


    // 修饰符：仅管理员
    modifier admin() {
        require(isAdmin(msg.sender), "AccessControl: Not an admin");
        _;
    }

    modifier trader() {
        require(isTrader(msg.sender), "AccessControl: Not an Trader");
        _;
    }

    constructor() {
        // 合约部署者成为管理员
        addAdmin(msg.sender);
    }

    // 设置角色
    function setRole(address user, Role role) public admin {
        require(role == Role.Admin || role == Role.Trader, "AccessControl: Invalid role");

        roles[user] = role;
        if (role == Role.Admin) {
            require(!isAdmin(user), "AccessControl: User is already an admin");
            require(!isTrader(user), "AccessControl: User is already a trader");
            addAdmin(user);
        } else if (role == Role.Trader) {
            require(!isAdmin(user), "AccessControl: User is already an admin");
            require(!isTrader(user), "AccessControl: User is already a trader");
            addTrader(user);
        }
 
        roles[user] = role;
        emit RoleSet(user, role);
    }

    // 移除角色
    function removeRole(address user) public admin {
        Role userRole = roles[user];
        require(userRole == Role.Admin || userRole == Role.Trader, "AccessControl: User has no role");

        if (userRole == Role.Admin) {
            require(isAdmin(user), "AccessControl: User is not an admin");
            removeAdmin(user);
        } else if (userRole == Role.Trader) {
            require(isTrader(user), "AccessControl: User is not a trader");
            removeTrader(user);
        }

        delete roles[user];
        emit RoleRemoved(user, userRole);
    }

    // 检查是否为管理员
    function isAdmin(address user) public view returns (bool) {
        for (uint i = 0; i < admins.length; i++) {
            if (admins[i] == user) {
                return true;
            }
        }
        return false;
    }

    // 检查是否为交易员
    function isTrader(address user) public view returns (bool) {
        for (uint i = 0; i < traders.length; i++) {
            if (traders[i] == user) {
                return true;
            }
        }
        return false;
    }

    // 添加管理员
    function addAdmin(address admin_) internal {
        admins.push(admin_);
        roles[admin_] = Role.Admin;
    }

    // 从管理员列表中移除地址
    function removeAdmin(address admin_) internal {
        for (uint i = 0; i < admins.length; i++) {
            if (admins[i] == admin_) {
                admins[i] = admins[admins.length - 1];
                admins.pop();
                break;
            }
        }
    }

    // 添加交易员
    function addTrader(address trader_) internal {
        traders.push(trader_);
        roles[trader_] = Role.Trader;
    }

    // 从交易员列表中移除地址
    function removeTrader(address trader_) internal {
        for (uint i = 0; i < traders.length; i++) {
            if (traders[i] == trader_) {
                traders[i] = traders[traders.length - 1];
                traders.pop();
                break;
            }
        }
    }

    // 获取管理员列表
    function getAdmins() public view returns (address[] memory) {
        return admins;
    }

    // 获取交易员列表
    function getTraders() public view returns (address[] memory) {
        return traders;
    }
}