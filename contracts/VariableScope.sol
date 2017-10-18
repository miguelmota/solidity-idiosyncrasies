pragma solidity ^0.4.4;

contract MyContract {
  function whileLoop() {
    uint i = 0;

    while (i++ < 1) {
      uint foo = 0;
    }

    /*
    while (i++ < 2) {
      // Illegal, second declaration of variable.
      uint foo = 0;
    }
    */
  }

  function forLoop() {
    for (uint i = 0; i < 1; i ++) {

    }

    /*
    // Illegal, second declaration of variable.
    for (uint i = 0; i < 1; i++) {

    }
    */
  }
}
