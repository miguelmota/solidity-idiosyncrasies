pragma solidity ^0.4.4;

contract MyContract {
  enum MyEnum {
    Foo,
    Bar,
    Qux
  }

  function MyContract() {
    assert(uint(MyEnum.Foo) == 0);
    assert(uint(MyEnum.Bar) == 1);
    assert(uint(MyEnum.Qux) == 2);
  }
}
