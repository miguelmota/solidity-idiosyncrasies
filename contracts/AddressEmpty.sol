pragma solidity ^0.4.4;

contract MyContract {
  function isEmptyAddress(address addr) returns (bool) {
    return (addr == address(0));
  }
}
