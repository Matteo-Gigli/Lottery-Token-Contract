//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./LotteriaToken.sol";
import "./Lotteria.sol";

pragma solidity ^0.8.7;

contract LotteriaInfo is Ownable{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;

    Lotteria  lottery;
    LotteriaToken private lotteryToken;

    struct itemToWin{
        string name;
        uint amountBettedOn;
        uint defaultTokenBase;
        address[] BidderAddress;
        uint endingTimeLottery;
    }

    event ItemCreated(uint tokenId, string name, uint amountBettedOn, uint defaultBid);


    mapping(uint=>itemToWin) private itemDescription;

    mapping(address=>bool)private SuccessRegistration;
    mapping(uint=>address)private ItemWinner;


    modifier onlyLotteria(){
        msg.sender == address(lottery);
        _;
    }

    modifier onlyLotteriaToken(){
        msg.sender == address(lotteryToken);
        _;
    }


    constructor(){

    }


    function initLotteryContract(address _lotteryContract)public onlyOwner{
        lottery = Lotteria(_lotteryContract);
    }


    function initLotteryTokenContract(address _lotteryTokenContract)public onlyOwner{
        lotteryToken = LotteriaToken(_lotteryTokenContract);
    }


    function setWinnerLottery(uint itemIndex, address winner)external onlyLotteria{
        ItemWinner[itemIndex] = winner;
    }


    function getWinner(uint itemIndex)public view returns(address){
        return ItemWinner[itemIndex];
    }


    function registrationSuccesfully(address addToCheck)external onlyLotteriaToken{
        SuccessRegistration[addToCheck] = true;
    }


    function registrationStatus(address addToCheck)public view returns(bool){
        return SuccessRegistration[addToCheck];
    }


    function setItemToWin(
        string memory _name,
        uint _defaultBid,
        uint _endingTimeLottery
        )public onlyLotteria{
            _tokenId.increment();
            uint newId = _tokenId.current();
            itemDescription[newId] = itemToWin(
                _name,
                0,
                _defaultBid,
                new address[](0),
                _endingTimeLottery
            );
        emit ItemCreated(newId, _name, 0, _defaultBid);
    }


    function updateBid(uint _tokenIds, uint _amount)external onlyLotteria{
        itemDescription[_tokenIds].amountBettedOn += _amount;
    }

    function updateAddress(uint _tokenIds, address _bidder)external onlyLotteria{
        itemDescription[_tokenIds].BidderAddress.push(_bidder);
    }

    function getItemName(uint _tokenIds)public view returns(string memory){
        return itemDescription[_tokenIds].name;
    }

    function getBidderAddress(uint _tokenIds)public view returns(address[]memory){
        return itemDescription[_tokenIds].BidderAddress;
    }

    function getDefaultStartingPrice(uint _tokenIds)public view returns(uint){
        return itemDescription[_tokenIds].defaultTokenBase;
    }

    function getEndingTimeLottery(uint _tokenIds)public view returns(uint){
        return itemDescription[_tokenIds].endingTimeLottery;
    }

    function getBidAmount(uint _tokenIds)public view returns(uint){
        return itemDescription[_tokenIds].amountBettedOn;
    }
}

