pragma solidity ^0.4.4;

contract StorageOverride {
  uint foo;
  uint[] bar;

  /*
  // This will not work!
  function StorageOverride () {
    uint[] x;
    x.push(1);
    bar = x;
  }
  */

  function StorageOverride () {
    uint[] memory x = new uint[](5);
    x[0] = 1;
    bar = x;

    assert(foo == 0);
    assert(bar[0] == 1);
  }
}
