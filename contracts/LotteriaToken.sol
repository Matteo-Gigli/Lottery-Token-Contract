//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./LotteriaInfo.sol";
import "./Lotteria.sol";

pragma solidity ^0.8.7;

contract LotteriaToken is Ownable, ERC20{

    uint private registrationAmountTokens = 5;
    mapping(address=>uint)private _balances;
    LotteriaInfo private lotteryInfo;
    Lotteria private lottery;

    constructor(string memory name, string memory symbol, uint totalSupply)ERC20(name, symbol){
        _mint(msg.sender, totalSupply);
        _balances[msg.sender] = totalSupply;

    }

    function initLotteryContract(address _lotteryContract)public onlyOwner{
        lottery = Lotteria(_lotteryContract);
    }

    function getLotteryContract()public view returns(address){
        return address(lottery);
    }


    function initLotteryInfoContract(address _lotteryInfoContract)public onlyOwner{
        lotteryInfo = LotteriaInfo(_lotteryInfoContract);
    }

    function getLotteryInfoContract()public view returns(address){
        return address(lotteryInfo);
    }


    function _transfer(
        address _from,
        address _to,
        uint _amount
        )internal virtual override{
            _balances[_from] -= _amount;
            _balances[_to] += _amount;
            super._transfer(_from, _to, _amount);
        }


    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual override {
        super._approve(owner, spender, amount);
    }



    function withdraw()external{
        require(msg.sender != owner(), "Cannot Claim Your Own Tokens!");
        require(balanceOf(owner()) >= registrationAmountTokens, "No More Tokens!");
        require(lotteryInfo.registrationStatus(msg.sender) == false, "Tokens Already Withdrawed!");
        _transfer(owner(), msg.sender, registrationAmountTokens);
        lotteryInfo.registrationSuccesfully(msg.sender);
        _approve(msg.sender, address(lottery), registrationAmountTokens);
    }



    function sendToken(address _to, uint _amount)external{
        require(_balances[msg.sender] >= _amount, "No Necessary Funds!");
        require(msg.sender != owner(), "Admin send tokens only during the withdraw!");
        _transfer(msg.sender, _to, _amount);
        _approve(msg.sender, address(lottery), _amount);
    }



    function balanceOf(address addToCheck)public view virtual override returns(uint){
        return _balances[addToCheck];
    }

}
