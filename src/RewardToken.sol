pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RewardToken is ERC20 {
    address private owner;
    
    constructor() ERC20("RewardToken", "RT") {
        owner = msg.sender;
    }

    function mint(address to, uint amount) external {
        require(msg.sender == owner, "NOT_OWNER");
        _mint(to, amount);
    }
}