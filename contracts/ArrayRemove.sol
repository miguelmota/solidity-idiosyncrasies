pragma solidity ^0.4.4;

contract MyContract {
  uint[] array = [1,2,3];

  function removeAtIndex(uint index) returns (uint[]) {
    if (index >= array.length) return;

    for (uint i = index; i < array.length-1; i++) {
      array[i] = array[i+1];
    }

    array.length--;

    return array;
  }
}
