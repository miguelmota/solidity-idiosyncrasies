pragma solidity ^0.4.4;

contract MyContract {
  struct MyStruct {
    string str;
    uint i;
  }

  MyStruct myStruct;

  function MyContract() {
    myStruct = MyStruct("foo", 1);
  }

  function myMethod() external returns (string, uint) {
    return (myStruct.str, myStruct.i);
  }
}
