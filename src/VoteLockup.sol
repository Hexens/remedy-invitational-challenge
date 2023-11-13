pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "./Config.sol";
import "./RewardToken.sol";

contract VoteLockup is ERC20Votes, Config {
    using SafeERC20 for IERC20;

    IERC20 public immutable token;
    RewardToken public immutable rewardToken;

    struct Lock {
        address owner;
        uint balance;
        uint period;
        uint untilTimestamp;
    }

    uint public lockCounter;
    mapping(uint => Lock) public locks;

    modifier onlyOwner() {
        require(msg.sender == _owner(), "ONLY_OWNER");
        _;
    }

    constructor(IERC20 _token) ERC20("VoteLockup", "VL") ERC20Permit("VoteLockup") {
        token = _token;
        rewardToken = new RewardToken();
    }

    function lock(uint amount, uint period) external {
        require(amount > 0, "NO_TOKENS");
        require(period >= _minLockupPeriod(), "TOO_SHORT");
        require(period <= _maxLockupPeriod(), "TOO_LONG");

        token.safeTransferFrom(msg.sender, address(this), amount);
        locks[++lockCounter] = Lock(msg.sender, amount, period, block.timestamp + period);

        _mint(msg.sender, amount);
    }

    function unlock(uint tokenId) external {
        Lock memory userLock = locks[tokenId];

        require(msg.sender == userLock.owner, "NOT_LOCK_OWNER");
        require(block.timestamp >= userLock.untilTimestamp, "NOT_EXPIRED");

        delete locks[tokenId];

        _burn(msg.sender, userLock.balance);
        token.safeTransfer(msg.sender, userLock.balance);

        uint rewards = (userLock.balance * userLock.period * 1 ether) / _rewardRate();
        rewardToken.mint(msg.sender, rewards);
    }

    function transferLock(uint tokenId, address to) external {
        Lock storage userLock = locks[tokenId];

        require(msg.sender == userLock.owner, "NOT_LOCK_OWNER");
        require(msg.sender != to, "NO_SELF_TRANSFER");
        require(block.timestamp < userLock.untilTimestamp, "LOCK_EXPIRED");
        require(delegates(to) == address(0) || delegates(msg.sender) == delegates(to), "UNAUTHORIZED_CHANGE");

        _delegate(to, delegates(msg.sender));
        _delegate(msg.sender, address(0));

        _transfer(msg.sender, to, userLock.balance);
        userLock.owner = to;
    }

    function setRewardRate(uint rate) external onlyOwner {
        _setRewardRate(rate);
    }

    function setMinLockupPeriod(uint period) external onlyOwner {
        _setMinLockupPeriod(period);
    }

    function setMaxLockupPeriod(uint period) external onlyOwner {
        _setMaxLockupPeriod(period);
    }

    function setPendingOwner(address pendingOwner) external onlyOwner {
        require(pendingOwner != address(0), "INVALID_OWNER");
        _setPendingOwner(pendingOwner);
    }

    function claimOwner() external {
        require(msg.sender == _pendingOwner(), "ONLY_PENDING_OWNER");
        _setPendingOwner(address(0));
        _setOwner(msg.sender);
    }

    function renounceOwnership() external onlyOwner {
        _setPendingOwner(address(0));
        _setOwner(address(0));
    }

    function emergencyRescue() external {
        require(msg.sender == _owner(), "ONLY_OWNER");
        token.safeTransfer(msg.sender, token.balanceOf(address(this)));
    }
}