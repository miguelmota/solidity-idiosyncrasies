pragma solidity ^0.4.4;

contract MyContract {
  enum MyEnum {
    string foo;
    string bar;
  }

  function MyContract() {
    assert(MyEnum.bar == 1);
  }
}
