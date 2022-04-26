# Lottery-Token-Contract

<h2>⛔️ Before everything: </h2>
<h4>Run Ganache.</h4>
<br></br>

<h2>🔨 Built with: </h2>
<h4>Solidity, Truffle, Ganache.</h4>

<br></br>

<h2>📃 Project: </h2>

<h4>The idea is to partecipate to a Lottery.</h4>
<h4>To partecipate we need some tokens.</h4>
<h4>So the first contract is the token contract where we are creating a new ERC20 token for our Lottery.</h4>
<h4>Then we deploy all the other contracts.</h4>
<h4>The first thing we are going to do is, using all the init functions in the different contracts.
<h4>In this moment we are going to initialize our contracts so be sure to initialize the right address, for example the initLotteryContract function in LotteriaToken.sol, must to be setted with the address where the LotteryContract is deployed.</h4>
<br></br>

<h3>LotteriaToken.sol</h3>
<h4>Is an ERC20 Contract, but there are some functions to explain: </h4>
<h4>First of all, we can see a onlyLotteria modifier, that is made to be able to call a function(buyTokens) from the Lotteria Contract, and is related to the sendToken(address _to, uint _amount) function in LotteriaToken.sol contract.</h4>
<h4>Is possible to call withdraw function only once to get 5 free tokens(kind of registration bonus), then if we finish the bonus tokens we'll be able to buy some more at 0.2 ether from the buyTokens() function in Lotteria.sol contract.</h4>
<br></br>

<h3>Lotteria.sol</h3>
<h4>Here we have the lottery.</h4>
<h4>The owner of this contract is able to set an item to win, with a default bid and an ending time, by the setItemToWin(string memory _name,...) function.</h4>
<h4>First element setted as item to win will have _tokenIds as 1, the second one will be _tokenIds as 2....</h4>
<h4>To partecipate to a lottery, with a new address, we can withdraw our free tokens or buy token, and then use the placeABid(uint _tokenIds) function.</h4>
<h4>We can check all the information for a an item, using the functions in LotteriInfo.sol contract.</h4>
<h4>pickTheWinner(uint _tokenIds) function will work only if the caller is the owner of the contract, a certain time is passed and the amount of address have made a bet is more or equal to 3.</h4>
<br></br>

<h3>LotteriaInfo.sol</h3>
<h4>Here we have all the information about al the transactions in our contracts.</h4>
<h4>Is really usefull, bacuse you can have a complete vision of your contracts, and use all the informations you need.</h4>
<br></br>

<h2>📣 Something to know:</h2>
<h4>This Example should be a base for a lottery, but more functions must to be implemented or improved.</h4>
<h4>For example in Lotteria.sol when we pick the winner, we don't delete the Item from the list of the item, so an item with a winner and expired will use the same _tokenIds forever</h4>
<h4>So if you like the project, feel free to use but make it better!</h4>
