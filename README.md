# Reverse Auction Contract

This repository contains a Solidity smart contract implementing a reverse auction. The contract is deployed and tested using Hardhat and can be interacted with via scripts using Ethers.js. Below are the detailed steps to set up, deploy, and interact with the contract.

---

## Prerequisites

Before starting, ensure you have the following installed:
- Node.js (v16 or v18 recommended)
- npm or yarn
- Hardhat

---

## Steps for Deploying the Contract on a Local Blockchain

### 1. Clone the Repository
```bash
git clone <repository-url>
cd <repository-folder>
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Compile the Contract
```bash
npx hardhat compile
```

### 4. Start a Local Hardhat Node
```bash
npx hardhat node
```

### 5. Deploy the Contract
Modify the deployment script located in `scripts/deploy.js` if needed. Then, run:
```bash
npx hardhat run scripts/deploy.js --network localhost
```

The script deploys the contract to the local Hardhat network and logs the contract address.

---

## Interacting with the Contract

### Interact via Hardhat Console

1. Open the Hardhat console:
```bash
npx hardhat console --network localhost
```

2. Load the Contract:
```javascript
const ReverseAuction = await ethers.getContractFactory("ReverseAuction");
const auction = await ReverseAuction.attach("<deployed-contract-address>");
```

3. Interact with the Contract:
- Submit a bid:
```javascript
await auction.submitBid({ value: ethers.utils.parseEther("0.5") });
```
- End the auction:
```javascript
await auction.endAuction();
```

---

### Example Input and Output

#### Deploying the Contract
Input:
```javascript
const ReverseAuction = await ethers.getContractFactory("ReverseAuction");
const auction = await ReverseAuction.deploy(3, ethers.utils.parseEther("1"), { value: ethers.utils.parseEther("3") });
await auction.deployed();
```

Output:
```
Contract deployed to: 0xYourContractAddress
```

#### Submitting Bids
Input:
```javascript
await auction.submitBid({ value: ethers.utils.parseEther("0.4") });
await auction.submitBid({ value: ethers.utils.parseEther("0.5") });
```

Output:
```
Bids submitted successfully.
```

#### Ending the Auction
Input:
```javascript
await auction.endAuction();
```

Output:
```
Auction ended. Rewards distributed.
```

---


