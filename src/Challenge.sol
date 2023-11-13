pragma solidity ^0.8.13;

import "src/Token.sol";
import "src/VoteLockup.sol";

contract Challenge {
    uint constant MINT_AMOUNT = 101 ether;
    uint constant LOCK_AMOUNT = 100 ether;
    uint constant CHALLENGER_AMOUNT = 1 ether;

    address public challenger;
    Token public token;
    VoteLockup public voteLockup;
    
    constructor() {
        challenger = msg.sender;

        token = new Token(MINT_AMOUNT);
        voteLockup = new VoteLockup(token);
        voteLockup.renounceOwnership();

        token.approve(address(voteLockup), LOCK_AMOUNT);
        voteLockup.lock(LOCK_AMOUNT, 365 days);

        token.transfer(challenger, CHALLENGER_AMOUNT);
    }

    function isSolved() external view returns (bool) {
        return
            token.balanceOf(address(voteLockup)) == 0 &&
            token.balanceOf(challenger) == MINT_AMOUNT;

    }
}