// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(uint mintAmount) ERC20("Token", "T") {
        _mint(msg.sender, mintAmount);
    }
}