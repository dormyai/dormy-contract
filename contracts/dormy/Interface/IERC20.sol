// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {

    // // 返回存在的代币总量。
    // function totalSupply() external view returns (uint256);

    // // 返回 account 持有的代币数量。
    // function balanceOf(address account) external view returns (uint256);

    // 将 amount 代币从调用者的账户移动到 recipient。
    // 返回一个布尔值表示操作是否成功。
    function transfer(address recipient, uint256 amount) external returns (bool);

    // // 返回 owner 允许 spender 提取的代币数量。
    // function allowance(address owner, address spender) external view returns (uint256);

    // // 设置 spender 可以从调用者的账户中提取的代币数量。
    // // 返回一个布尔值表示操作是否成功。
    // function approve(address spender, uint256 amount) external returns (bool);

    // 将 amount 代币从 sender 移动到 recipient，前提是调用者已获得足够的授权。
    // 返回一个布尔值表示操作是否成功。
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    // // 当代币数量被转移时触发，包括零值的转移。
    // event Transfer(address indexed from, address indexed to, uint256 value);

    // // 当调用 approve 函数成功时触发。
    // event Approval(address indexed owner, address indexed spender, uint256 value);
}
