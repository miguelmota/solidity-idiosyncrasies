pragma solidity ^0.4.4;

contract MyContract {
  function MyContract() {
    assert(myMethod() == 10);
  }

  function myMethod() returns (uint num) {
    num = 10;
    return num;
  }
}
