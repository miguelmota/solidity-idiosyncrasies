pragma solidity ^0.4.4;

contract MyContract {
  string str = "foo";

  function MyContract() {
    assert(size(str) == 3);
  }

  function size(string s) returns (uint) {
    return bytes(s).length;
  }
}
