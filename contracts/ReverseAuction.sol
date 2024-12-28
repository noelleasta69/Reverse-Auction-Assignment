// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReverseAuction {
    struct Bid {
        address bidder;
        uint256 amount;
    }

    address public auctionCreator;
    uint256 public maxBidAmount;
    uint256 public numWinners;
    uint256 public totalLockedFunds;
    Bid[] public bids;
    bool public auctionEnded;

    mapping(address => bool) public hasBid;

    constructor(uint256 _numWinners, uint256 _maxBidAmount) payable {
        require(_numWinners > 0, "Number of winners must be greater than zero");
        require(_maxBidAmount > 0, "Max bid amount must be greater than zero");
        require(msg.value >= _numWinners * _maxBidAmount, "Insufficient funds locked");

        auctionCreator = msg.sender;
        numWinners = _numWinners;
        maxBidAmount = _maxBidAmount;
        totalLockedFunds = msg.value;
    }

    function submitBid() external payable {
        require(!auctionEnded, "Auction has ended");
        require(msg.value > 0 && msg.value <= maxBidAmount, "Bid amount out of range");
        require(!hasBid[msg.sender], "You have already placed a bid");

        bids.push(Bid({bidder: msg.sender, amount: msg.value}));
        hasBid[msg.sender] = true;
    }

    function endAuction() external {
        require(msg.sender == auctionCreator, "Only the auction creator can end the auction");
        require(!auctionEnded, "Auction already ended");

        sortBids();

        uint256 highestWinningBid = bids[0].amount;
        uint256 totalReward = 0;

        for (uint256 i = 0; i < numWinners && i < bids.length; i++) {
            payable(bids[i].bidder).transfer(highestWinningBid);
            totalReward += highestWinningBid;
        }


        payable(auctionCreator).transfer(totalLockedFunds - totalReward);

        auctionEnded = true;
    }

    function sortBids() internal {
        for (uint256 i = 0; i < bids.length; i++) {
            for (uint256 j = i + 1; j < bids.length; j++) {
                if (bids[j].amount < bids[i].amount) {
                    Bid memory temp = bids[i];
                    bids[i] = bids[j];
                    bids[j] = temp;
                }
            }
        }
    }

    function getAllBids() external view returns (Bid[] memory) {
        return bids;
    }
}