// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControl {
    enum Role { None, Admin, Trader }

    mapping(address => Role) public roles;
    address[] public admins;   // 管理员地址列表
    address[] public traders;  // 交易员地址列表

    // 修饰符：仅管理员
    modifier onlyAdmin() {
        require(isAdmin(msg.sender), "AccessControl: Not an admin");
        _;
    }

    modifier onlyTrader() {
        require(isTrader(msg.sender), "AccessControl: Not an admin");
        _;
    }

    constructor() {
        // 合约部署者成为管理员
        addAdmin(msg.sender);
    }

    // 设置角色
    function setRole(address user, Role role) public onlyAdmin {
        roles[user] = role;
        if (role == Role.Admin) {
            addAdmin(user);
        } else if (role == Role.Trader) {
            addTrader(user);
        }
    }

    // 移除角色
    function removeRole(address user) public onlyAdmin {
        Role userRole = roles[user];
        if (userRole == Role.Admin) {
            removeAdmin(user);
        } else if (userRole == Role.Trader) {
            removeTrader(user);
        }
        roles[user] = Role.None;
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
    function addAdmin(address admin) internal {
        admins.push(admin);
        roles[admin] = Role.Admin;
    }

    // 从管理员列表中移除地址
    function removeAdmin(address admin) internal {
        for (uint i = 0; i < admins.length; i++) {
            if (admins[i] == admin) {
                admins[i] = admins[admins.length - 1];
                admins.pop();
                break;
            }
        }
    }

    // 添加交易员
    function addTrader(address trader) internal {
        traders.push(trader);
        roles[trader] = Role.Trader;
    }

    // 从交易员列表中移除地址
    function removeTrader(address trader) internal {
        for (uint i = 0; i < traders.length; i++) {
            if (traders[i] == trader) {
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