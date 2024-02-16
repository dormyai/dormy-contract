// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Interface/IBlast.sol";

contract MyContract {
    IBlast blast;
    //0x4300000000000000000000000000000000000002
    constructor(address _blastAddress) {
        blast = IBlast(_blastAddress);
    }

    // 设置为Void模式
    function setVoidYieldMode() public {
        blast.configureVoidYield();
    }

    // 设置为Automatic模式
    function setAutomaticYieldMode() public {
        blast.configureAutomaticYield();
    }

    // 设置为Claimable模式
    function setClaimableYieldMode() public {
        blast.configureClaimableYield();
    }
}
