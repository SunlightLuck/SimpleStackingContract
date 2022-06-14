pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleStackingContract is ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;

    uint256 public _initialTimestamp;
    bool public _timeStampSet;
    uint256 public _timePeriod;

    mapping(address => uint256) private _alreadyWithdrawn;
    mapping(address => uint256) private _balance;
    uint256 private _currentBalance;

    IERC20 private _erc20Contract;

    event tokensStaked(address from, uint256 amount);
    event tokensUnstaked(address to, uint256 amount);

    constructor(IERC20 ercContract) {
        _timeStampSet = false;
        _erc20Contract = ercContract;
    }

    modifier timeStampeNotSet() {
        require(_timeStampSet == false, "The timestamp has already been set.");
        _;
    }

    modifier timeStampIsSet() {
        require(_timeStampSet == true, "Please set the timestamp first.");
        _;
    }

    function setTimestamp(uint256 period) public onlyOwner timeStampeNotSet {
        _timeStampSet = true;
        _initialTimestamp = block.timestamp;
        _timePeriod = _initialTimestamp + period;
    }

    function stakeTokens(IERC20 token, uint256 amount)
        public
        timeStampIsSet
        nonReentrant
    {
        require(amount <= token.balanceOf(msg.sender), "Not enough tokens.");
        token.safeTransferFrom(msg.sender, address(this), amount);
        _balance[msg.sender] += amount;
        emit tokensStaked(msg.sender, amount);
    }

    function unstakeTokens(IERC20 token, uint256 amount)
        public
        timeStampIsSet
        nonReentrant
    {
        require(_balance[msg.sender] >= amount, "Insufficient tokens.");
        if (block.timestamp >= _timePeriod) {
            _alreadyWithdrawn[msg.sender] += amount;
            _balance[msg.sender] -= amount;
            token.safeTransfer(msg.sender, amount);
            emit tokensUnstaked(msg.sender, amount);
        } else {
            revert("Tokens are only available after time period has elapsed");
        }
    }
}
