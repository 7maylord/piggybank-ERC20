# PiggyBank (ERC-20 Version)

## Overview
The PiggyBank smart contract allows users to save ERC-20 tokens towards a target amount and withdraw them after a predefined date. It replaces native ETH deposits with ERC-20 token transfers.

## Features
- Allows users to contribute ERC-20 tokens to the PiggyBank.
- Supports a target savings amount.
- Prevents withdrawals until the withdrawal date is reached.
- Only the manager (owner) of the contract can withdraw funds after the target date.

## Installation & Setup
1. Clone the repository:
   ```sh
   git clone https://github.com/7maylord/piggybank-ERC20.git
   cd piggybank-ERC20
   ```
2. Install dependencies:
   ```sh
   npm install
   ```
3. Compile the smart contracts:
   ```sh
   npx hardhat compile
   ```

## Running Tests
To test the contract using Hardhat:
```sh
npx hardhat test
```

## Deployment
To deploy the contract, run:
```sh
npx hardhat ignition deploy ignition/modules/PiggyBank.ts --network <network-name> --verify
```
Replace `<network-name>` with your desired network (e.g., `lisk_sepolia`, `localhost`).

## Contract Address : Lisk Sepolia
   ```sh
   0xaa9a8A94Dfcb8a07Cc5d2241eE17f8ed7Dc28df4
   ```
   
## ERC20 Token Contract Address : Lisk Sepolia
   ```sh
   0x94080B43fA5Fc8C6Ffd3306c6D0541D80a870E98
   ```

## Usage
### Saving Tokens
1. Approve the PiggyBank contract to spend tokens on behalf of the contributor:
   ```js
   await token.connect(contributor).approve(piggyBank.address, depositAmount);
   ```
2. Save tokens:
   ```js
   await piggyBank.connect(contributor).save(depositAmount);
   ```

### Withdraw Funds
After the withdrawal date has passed, the manager can withdraw funds:
```js
await piggyBank.connect(manager).withdrawal();
```

## Events
- `Contributed(address indexed contributor, uint256 amount, uint256 totalBalance);`
- `Withdrawn(uint256 totalAmount, uint256 timestamp);`


## License
This contract is **UNLICENSED**, meaning it has no predefined license attached.

## Author
Developed by **[MayLord](https://github.com/7maylord)**. Feel free to contribute and improve the project!

---

Happy coding! 🚀
