pragma solidity ^0.4.4;

contract MyContract {
  uint nonce = 0;

  function rand(uint min, uint max) public returns (uint) {
    return uint(block.blockhash(block.number-1))%(min+max)-min;
  }
}
