//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./LotteriaToken.sol";
import "./LotteriaInfo.sol";

pragma solidity ^0.8.7;

contract Lotteria is Ownable{

    LotteriaInfo private lotteryInfo;
    LotteriaToken private lotteryToken;

    event BidCorrect(address bidder, uint tokenId, uint defaultBid);

    constructor(){

    }


    function initLotteryTokenContract(address _lotteryTokenContract)public onlyOwner{
        lotteryToken = LotteriaToken(_lotteryTokenContract);
    }

    function getLotteryTokenContract()public view returns(address){
        return address(lotteryToken);
    }


    function initLotteryInfoContract(address _lotteryInfoContract)public onlyOwner{
        lotteryInfo = LotteriaInfo(_lotteryInfoContract);
    }

    function getLotteryInfoContract()public view returns(address){
        return address(lotteryInfo);
    }


    function setItemToWin(
        string memory _name,
        uint _defaultBid,
        uint _endingTimeLottery
        )public onlyOwner{
            require(_endingTimeLottery > block.timestamp, "Cannot set a date in the Past!");
            lotteryInfo.setItemToWin(_name, _defaultBid, _endingTimeLottery);
    }



    function placeABid(uint _tokenIds)external{
        require(block.timestamp < lotteryInfo.getEndingTimeLottery(_tokenIds), "Lottery is closed!");
        require(msg.sender != owner(), "Admin Cannot Place A Bid!");
        uint requiredTokenAmounts = lotteryInfo.getDefaultStartingPrice(_tokenIds);
        require(lotteryToken.balanceOf(msg.sender) >= requiredTokenAmounts, "No Necessary Funds To Partecipate!");
        lotteryToken.transferFrom(msg.sender, owner(), requiredTokenAmounts);
        lotteryInfo.updateBid(_tokenIds, requiredTokenAmounts);
        lotteryInfo.updateAddress(_tokenIds, msg.sender);
        emit BidCorrect(msg.sender, _tokenIds, requiredTokenAmounts);
    }

    function random(uint _tokenIds) internal view returns(uint){
        uint bidderAddressCount = lotteryInfo.getBidderAddress(_tokenIds).length;
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, bidderAddressCount)));
    }


    function pickTheWinner(uint _tokenIds)public onlyOwner{
        require(block.timestamp > lotteryInfo.getEndingTimeLottery(_tokenIds), "Can't pick the winner yet!");
        uint bidderAddressCount = lotteryInfo.getBidderAddress(_tokenIds).length;
        address[]memory bidderAddress = lotteryInfo.getBidderAddress(_tokenIds);
        require(bidderAddressCount > 3, "Not enough address to pick the winner!");
        address winner = bidderAddress[random(_tokenIds) % bidderAddressCount];
        lotteryInfo.setWinnerLottery(_tokenIds, winner);
    }
}
