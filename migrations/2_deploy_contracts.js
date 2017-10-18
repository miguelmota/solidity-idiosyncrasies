var SafeMath = artifacts.require('./SafeMath.sol');
var MemoryArray = artifacts.require('./MemoryArray.sol');
var StorageOverride = artifacts.require('./StorageOverride.sol');

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.deploy(MemoryArray);
  deployer.deploy(StorageOverride);
};
