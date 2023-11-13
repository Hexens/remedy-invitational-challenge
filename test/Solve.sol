// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Challenge.sol";
import "src/Token.sol";
import "src/VoteLockup.sol";

contract Solve is Test {

    function testSolve() public {
        
        Challenge challenge = new Challenge();

        /*
        
            Your exploit code here

         */

        assert(challenge.isSolved());
    }
}
