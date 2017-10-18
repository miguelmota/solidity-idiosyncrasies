pragma solidity ^0.4.4;

contract MyContract {
  function MyContract() {
    /* This creates a `TypeError` because uint8[3] memory
     * can't be converted to uint256[] memory.
     */
    // uint[3] memory x = [1, 2, 3];

    // This works, because it's the same common type.
    uint8[3] memory y = [1, 2, 3];

    // This works, because it's the same common type.
    uint16[3] memory z = [256, 2, 3];
  }
}
