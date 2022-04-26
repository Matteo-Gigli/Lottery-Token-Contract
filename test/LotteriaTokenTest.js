const LotteriaToken = artifacts.require("LotteriaToken");
const Lotteria = artifacts.require("Lotteria");
const LotteriaInfo = artifacts.require("LotteriaInfo");


contract("LotteriaToken Contract testing function", function(accounts){


    it("Should get the right balance of 1000 tokens to the first account", async()=>{
        let instance = await LotteriaToken.deployed();
        let balanceAccount0 = await instance.balanceOf(accounts[0]);
        assert.equal(balanceAccount0, 1000);
    });

    it("Should initialize the Lotteria Contract, Only the Owner can do that!", async()=>{
        let instance = await LotteriaToken.deployed();
        let lotteriaInstance = await Lotteria.deployed();
        await instance.initLotteryContract(lotteriaInstance.address);
        let lotteriaInstanceResult = await instance.getLotteryContract();
        let owner = await instance.owner();
        assert.equal(lotteriaInstance.address, lotteriaInstanceResult);
        assert.equal(owner, accounts[0]);
    });


    it("Should initialize the LotteriaInfo Contract, Only the Owner can do that", async()=>{
        let instance = await LotteriaToken.deployed();
        let lotteriaInfoContract = await LotteriaInfo.deployed();
        await instance.initLotteryInfoContract(lotteriaInfoContract.address);
        let lotteriaInfoContractResult = await instance.getLotteryInfoContract();
        let owner = await instance.owner();
        assert.equal(lotteriaInfoContract.address, lotteriaInfoContractResult);
        assert.equal(owner, accounts[0]);
    });


    it("Should be able to withdraw 5 tokens to start, everyone except the owner", async()=>{
        let instance = await LotteriaToken.deployed();
        let lotteriaInfoContract = await LotteriaInfo.deployed();
        await instance.withdraw({from:accounts[1]});
        let ownerBalance = await instance.balanceOf(accounts[0]);
        let newUserBalance = await instance.balanceOf(accounts[1]);
        await lotteriaInfoContract.registrationSuccesfully(accounts[1]);
        let registrationStatus = await lotteriaInfoContract.registrationStatus(accounts[1]);
        assert.equal(ownerBalance, 995);
        assert.equal(newUserBalance, 5);
        assert.equal(registrationStatus, true);
    });








})