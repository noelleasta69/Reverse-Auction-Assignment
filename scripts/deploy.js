const { ethers } = require("hardhat");

async function main() {
  // Get the contract factory
  const ReverseAuction = await ethers.getContractFactory("ReverseAuction");

  // Deploy the contract
  // Parameters: 3 winners, max bid 1 ETH, initial funds 3 ETH
  const auction = await ReverseAuction.deploy(
    3, // number of winners
    ethers.parseEther("1"), // max bid amount (1 ETH)
    { value: ethers.parseEther("3") } // initial funds (3 ETH)
  );

  await auction.waitForDeployment();

  const address = await auction.getAddress();
  console.log("ReverseAuction deployed to:", address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });