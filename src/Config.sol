pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/StorageSlot.sol";

contract Config {
    using StorageSlot for bytes32;

    // keccak256(abi.encodePacked(COUNTER, NAME, VERSION))
    // (uint128(0), "VoteLockup.rewardRate", uint256(9))
    bytes32 constant REWARD_RATE_SLOT = 0x7bc22115e5cd3713a0f6721303f7eb2389262fa5d009845c6c51b310d68ca352;
    // (uint128(1), "VoteLockup.minLockupPeriod", uint256(9))
    bytes32 constant MIN_LOCKUP_PERIOD_SLOT = 0x3f46bd0aba5226434523d391004bb9f814291a0dc2d3bacc563bf6c3583644f2;
    // (uint128(2), "VoteLockup.maxLockupPeriod", uint256(9))
    bytes32 constant MAX_LOCKUP_PERIOD_SLOT = 0xcd5fe05096455ae720c1f27bac9d8e5496a6c821af1c001f4e50c0d3c53f27b6;
    // (uint128(3), "VoteLockup.owner", uint256(9))
    bytes32 constant OWNER_SLOT = 0x1c74dc1e791d52b055e12f7becf77d0eadb955c09f51ff245f7130b2a5096380;
    // (uint128(4), "VoteLockup.pendingOwner", uint256(9))
    bytes32 constant PENDING_OWNER_SLOT = 0x04a5b7bff5b90659a111a7f3aa8e617c4544923811334d130f59ef4248663d8c;

    constructor() {
        REWARD_RATE_SLOT.getUint256Slot().value = uint(10 ether) * uint(365 days); // 10% APY
        MIN_LOCKUP_PERIOD_SLOT.getUint256Slot().value = uint(7 days);
        MAX_LOCKUP_PERIOD_SLOT.getUint256Slot().value = uint(365 days);
        OWNER_SLOT.getAddressSlot().value = msg.sender;
    }

    function _setRewardRate(uint rate) internal {
        REWARD_RATE_SLOT.getUint256Slot().value = rate;
    }

    function _rewardRate() internal view returns (uint) {
        return REWARD_RATE_SLOT.getUint256Slot().value;
    }

    function _setMinLockupPeriod(uint period) internal {
        MIN_LOCKUP_PERIOD_SLOT.getUint256Slot().value = period;
    }

    function _minLockupPeriod() internal view returns (uint) {
        return MIN_LOCKUP_PERIOD_SLOT.getUint256Slot().value;
    }

    function _setMaxLockupPeriod(uint period) internal {
        MAX_LOCKUP_PERIOD_SLOT.getUint256Slot().value = period;
    }

    function _maxLockupPeriod() internal view returns (uint) {
        return MAX_LOCKUP_PERIOD_SLOT.getUint256Slot().value;
    }

    function _setOwner(address owner) internal {
        OWNER_SLOT.getAddressSlot().value = owner;
    }

    function _owner() internal view returns (address) {
        return OWNER_SLOT.getAddressSlot().value;
    }

    function _setPendingOwner(address pendingOwner) internal {
        PENDING_OWNER_SLOT.getAddressSlot().value = pendingOwner;
    }

    function _pendingOwner() internal view returns (address) {
        return PENDING_OWNER_SLOT.getAddressSlot().value;
    }
}