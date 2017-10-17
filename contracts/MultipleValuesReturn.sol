pragma solidity ^0.4.4;

contract MyContract {
  struct MyStruct {
    uint foo;
    string bar;
  }

  MyStruct myStruct;

  function MyContract() {
    myStruct = MyStruct(10, "hello");
  }

  function myMethod() external returns (uint, string) {
    return (myStruct.foo, myStruct.bar);
  }
}
