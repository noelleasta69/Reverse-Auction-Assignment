const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ReverseAuction", function () {
    let auction;
    let owner;
    let addr1;
    let addr2;
    let addr3;

    beforeEach(async function () {
        [owner, addr1, addr2, addr3] = await ethers.getSigners();

        const ReverseAuction = await ethers.getContractFactory("ReverseAuction");
        auction = await ReverseAuction.deploy(
            3, 
            ethers.parseEther("1"), 
            { value: ethers.parseEther("3") }
        );
        await auction.waitForDeployment();
    });

    it("should accept bids", async function () {
        await auction.connect(addr1).submitBid({ value: ethers.parseEther("0.5") });
        await auction.connect(addr2).submitBid({ value: ethers.parseEther("0.4") });
        const bids = await auction.getAllBids();
        expect(bids.length).to.equal(2);
    });

    it("should distribute rewards to lowest bidders", async function () {
        await auction.connect(addr1).submitBid({ value: ethers.parseEther("0.5") });
        await auction.connect(addr2).submitBid({ value: ethers.parseEther("0.4") });
        await auction.connect(addr3).submitBid({ value: ethers.parseEther("0.6") });

        await auction.endAuction();


        const balance = await ethers.provider.getBalance(addr1.address);
        expect(balance).to.be.above(ethers.parseEther("0.5"));
    });
});