pragma solidity ^0.4.4;

contract MemoryArray {
  uint[] foo;

  function MemoryArray () {
    uint[] memory bar = new uint[](5);
    bytes memory qux = new bytes(5);

    // dynamically resize storage array
    foo.length = 6;
    foo[5] = 1;
    assert(foo[5] == 1);

    // doesn't work
    // bar.length = 6;
    // qux.length = 6;
  }
}
