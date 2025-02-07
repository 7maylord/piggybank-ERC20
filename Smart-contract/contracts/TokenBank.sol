// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PiggyBank {
    // State variables
    IERC20 public token;
    uint256 public targetAmount;
    uint256 public immutable withdrawalDate;
    uint8 public contributorsCount;
    address public manager;

    //Mapping
    mapping(address => uint256) public contributions;

    // Events
    event Contributed(address indexed contributor, uint256 amount, uint256 time);
    event Withdrawn(uint256 amount, uint256 time);

    // Constructor
    constructor(address _token, uint256 _targetAmount, uint256 _withdrawalDate, address _manager) {
        require(_withdrawalDate > block.timestamp, "WITHDRAWAL MUST BE IN FUTURE");
        require(_token != address(0), "INVALID TOKEN ADDRESS");
        
        token = IERC20(_token);
        targetAmount = _targetAmount;
        withdrawalDate = _withdrawalDate;
        manager = _manager;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "YOU WAN THIEF ABI ?");
        _;
    }

    // Save (Deposit tokens)
    function save(uint256 amount) external {
        require(msg.sender != address(0), "UNAUTHORIZED ADDRESS");
        require(block.timestamp <= withdrawalDate, "YOU CAN NO LONGER SAVE");
        require(amount > 0, "YOU ARE BROKE");
        require(token.transferFrom(msg.sender, address(this), amount), "TRANSFER FAILED");

        // Check if the caller is a first-time contributor
        if (contributions[msg.sender] == 0) {
            contributorsCount += 1;
        }

        contributions[msg.sender] += amount;
        emit Contributed(msg.sender, amount, block.timestamp);
    }

    // Withdrawal
    function withdraw() external onlyManager {
        require(block.timestamp >= withdrawalDate, "NOT YET TIME");
        require(token.balanceOf(address(this)) >= targetAmount, "TARGET AMOUNT NOT REACHED");

        uint256 contractBalance = token.balanceOf(address(this));
        require(token.transfer(manager, contractBalance), "TRANSFER FAILED");

        emit Withdrawn(contractBalance, block.timestamp);
    }
}
