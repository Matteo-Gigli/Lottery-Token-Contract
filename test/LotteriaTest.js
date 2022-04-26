const Lotteria = artifacts.require("Lotteria");
const LotteriaToken = artifacts.require("LotteriaToken");
const LotteriaInfo = artifacts.require("LotteriaInfo");

const helper = require("./helpers/truffleTestHelper");

contract("LotteriaContract testing functions", function(accounts){


    it("Should initialize the right LotteriaTokenContract", async()=>{
        let instance = await Lotteria.deployed();
        let lotteriaTokenInstance = await LotteriaToken.deployed();
        await instance.initLotteryTokenContract(lotteriaTokenInstance.address);
        let getLotteryTokenContract = await instance.getLotteryTokenContract();
        assert.equal(lotteriaTokenInstance.address, getLotteryTokenContract);
    });

    it("Should initialize the right LotteriaInfoContract", async()=>{
        let instance = await Lotteria.deployed();
        let lotteriaInfoInstance = await LotteriaInfo.deployed();
        await instance.initLotteryInfoContract(lotteriaInfoInstance.address);
        let getLotteryInfoContract = await instance.getLotteryInfoContract();
        assert.equal(lotteriaInfoInstance.address, getLotteryInfoContract);
    });


    it("Should create an item to sell", async()=>{
        let instance = await Lotteria.deployed();
        let lotteriaInfoInstance = await LotteriaInfo.deployed();
        await instance.setItemToWin("Auto", 2, 1650988528);
        let name = await lotteriaInfoInstance.getItemName(1);
        let defaultTokensBid = await lotteriaInfoInstance.getDefaultStartingPrice(1);
        let closingBid = await lotteriaInfoInstance.getEndingTimeLottery(1);
        assert.equal(name, "Auto");
        assert.equal(defaultTokensBid, 2);
        assert.equal(closingBid, 1650988528);
    });


    it("Should be able to set a bid for a specific item, everyone except the owner", async()=>{
        let instance = await Lotteria.deployed();
        let lotteriaInfoInstance = await LotteriaInfo.deployed();
        let lotteriaTokenInstance = await LotteriaToken.deployed();
        await lotteriaTokenInstance.initLotteryContract(instance.address);
        await lotteriaTokenInstance.initLotteryInfoContract(lotteriaInfoInstance.address);
        await lotteriaTokenInstance.withdraw({from: accounts[2]});
        await instance.setItemToWin("Auto", 2, 1650988528);
        let balance = await lotteriaTokenInstance.balanceOf(accounts[2]);
        assert.equal(balance, 5);
        await instance.placeABid(1, {from:accounts[2]});
        let bidAmount = await lotteriaInfoInstance.getBidAmount(1);
        assert.equal(bidAmount, 2);
    });


    it("Should be able to pick the winner, Only owner can do that", async()=> {
        let instance = await Lotteria.deployed();
        let lotteriaInfoInstance = await LotteriaInfo.deployed();
        let lotteriaTokenInstance = await LotteriaToken.deployed();
        await lotteriaTokenInstance.initLotteryContract(instance.address);
        await lotteriaTokenInstance.initLotteryInfoContract(lotteriaInfoInstance.address);
        await lotteriaTokenInstance.withdraw({from: accounts[3]});
        await lotteriaTokenInstance.withdraw({from: accounts[4]});
        await lotteriaTokenInstance.withdraw({from: accounts[5]});
        await instance.setItemToWin("Auto", 2, 1650988528);
        await instance.placeABid(1, {from: accounts[3]});
        await instance.placeABid(1, {from: accounts[4]});
        await instance.placeABid(1, {from: accounts[5]});
        const advancement = 600;
        const originalBlock = web3.eth.getBlock('latest');
        const newBlock = await helper.advanceTiming(advancement);
        await instance.pickTheWinner(1);
        let winnerIs = await lotteriaInfoInstance.getWinner(1);

        console.log(winnerIs);
    })


    it("Should be able to buy some tokens, except the admin!", async()=>{
        let instance = await Lotteria.deployed();
        let tokenInstance = await LotteriaToken.deployed();
        await instance.initLotteryTokenContract(tokenInstance.address);
        await instance.buyTokens({from: accounts[7], value: 200000000000000000});
        let newBalanceAfterBuying = await tokenInstance.balanceOf(accounts[7]);
        assert.equal(parseFloat(newBalanceAfterBuying), 10);
        console.log(newBalanceAfterBuying);
    })
})