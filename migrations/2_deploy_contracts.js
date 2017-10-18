var SafeMath = artifacts.require("./SafeMath.sol");
var MemoryArray = artifacts.require("./MemoryArray.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.deploy(MemoryArray);
};
