pragma solidity ^0.4.4;

contract MyContract {
  function publicCalculate(uint[20] a) public returns (uint){
       return a[10]*2;
  }

  function externalCalcuate(uint[20] a) external returns (uint){
       return a[10]*2;
  }
}
