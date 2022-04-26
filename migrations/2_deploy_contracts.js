const LotteriaToken = artifacts.require("LotteriaToken");

module.exports = function (deployer) {
  deployer.deploy(LotteriaToken, "MyToken", "MTK", 1000);
};
