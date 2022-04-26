const Lotteria = artifacts.require("Lotteria");

module.exports = function (deployer) {
  deployer.deploy(Lotteria);
};
