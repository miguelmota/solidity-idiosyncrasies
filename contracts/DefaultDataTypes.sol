pragma solidity ^0.4.4;

contract MyContract {
  int n; // 0
  string str; // ""
  address addr; // 0x0000000000000000000000000000000000000000
  bool b; // false

  function MyContract() {
    assert(n == 0);
    assert(sha3(str) == "");
    assert(addr == address(0));
    assert(b == false);
  }
}
