pragma solidity ^0.4.4;

contract MyContract {
  function loop() {
    /* `i` will have max a max value of 255 (initialized as uint8),
     * causing an infinite loop.
     */
    for (var i = 0; i < 1000; i++) {

    }
  }
}
