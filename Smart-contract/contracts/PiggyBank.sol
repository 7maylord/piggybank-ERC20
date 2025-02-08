// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import "./IERC20.sol";

contract PiggyBank {
    // State variables
    uint256 public targetAmount;
    mapping(address => uint256) public contributions;
    uint256 public immutable withdrawalDate;
    uint8 public contributorsCount;
    address public manager;
    IERC20 public token; // ERC-20 token address

    // Events
    event Contributed(address indexed contributor, uint256 amount, uint256 time);
    event Withdrawn(uint256 amount, uint256 time);

    // Constructor
    constructor(uint256 _targetAmount, uint256 _withdrawalDate, address _manager, address _token) {
        require(_withdrawalDate > block.timestamp, "WITHDRAWAL MUST BE IN FUTURE");
        require(_manager != address(0), "INVALID SENDER ADDRESS");
        require(_token != address(0), "INVALID TOKEN ADDRESS");

        targetAmount = _targetAmount;
        withdrawalDate = _withdrawalDate;
        manager = _manager;
        token = IERC20(_token);
    }

    modifier onlyManager() {
        require(msg.sender == manager, "YOU WAN THIEF ABI ?");
        _;
    }

    // Save (Deposit Tokens)
    function save(uint256 amount) external {
        require(msg.sender != address(0), "UNAUTHORIZED ADDRESS");
        require(block.timestamp <= withdrawalDate, "YOU CAN NO LONGER SAVE");
        require(amount > 0, "YOU ARE BROKE");

        // Transfer tokens from sender to contract
        require(token.transferFrom(msg.sender, address(this), amount), "TOKEN TRANSFER FAILED");

        // First-time contributor check
        if (contributions[msg.sender] == 0) {
            contributorsCount += 1;
        }

        contributions[msg.sender] += amount;
        emit Contributed(msg.sender, amount, block.timestamp);
    }

    // Withdrawal
    function withdrawal() external onlyManager {
        require(block.timestamp >= withdrawalDate, "NOT YET TIME");
        require(token.balanceOf(address(this)) >= targetAmount, "TARGET AMOUNT NOT REACHED");

        uint256 contractBalance = token.balanceOf(address(this));

        // Transfer tokens to manager
        require(token.transfer(manager, contractBalance), "TOKEN TRANSFER FAILED");

        emit Withdrawn(contractBalance, block.timestamp);
    }
}
