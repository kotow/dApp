var CURToken = artifacts.require("./CURToken.sol");

module.exports = function(deployer) {
  deployer.deploy(CURToken);
};
