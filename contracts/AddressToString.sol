pragma solidity ^0.4.4;

contract MyContract {
  string public str;

  function MyContract() {
    str = toString(msg.sender);
  }

  function toString(address addr) returns (string) {
    bytes memory b = new bytes(20);
    for (uint i = 0; i < 20; i++)
    b[i] = byte(uint8(uint(addr) / (2**(8*(19 - i)))));
    return string(b);
  }
}
