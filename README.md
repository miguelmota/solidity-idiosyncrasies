# Solidity idiosyncrasies

> [Solidity](https://github.com/ethereum/solidity) gotchas, pitfalls, limitations, and idiosyncrasies.

This is a list of things that have caused me to bang my head against a brick wall when coming across them in solidity, especially when starting out as a beginner.

<img src="headbang.gif" width="80" />

---

In no particular order:

- **Using `delete` on an array leaves a gap**; need to shift items manually and update the `length` property.

  ```solidity
  contract MyContract {
    uint[] array = [1,2,3];

    function removeAtIndex(uint index) returns (uint[]) {
      if (index >= array.length) return;

      for (uint i = index; i < array.length-1; i++) {
        array[i] = array[i+1];
      }

      delete array[array.length-1];
      array.length--;

      return array;
    }
  }
  ```

- **Can't return `struct` for `external` methods**; need to return multiple values.

  ```solidity
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
  ```

- **Can't compare two `string`s**; one workaround is to compare the `sha3` hashes of the strings.

  ```solidity
  contract MyContract {
    function compare(string s1, string s2) returns (bool) {
      return (sha3(s1) == sha3(s2));
    }
  }
  ```

  or compare `byte` by `byte`. The helper library [solidity-stringutils](https://github.com/Arachnid/solidity-stringutils) has good examples.

- **Can't compare `address` to `0` to check if it's empty**; need to compare to `address(0)`.

  ```solidity
  contract MyContract {
    function isEmptyAddress(address addr) returns (bool) {
      return (addr == address(0));
    }
  }
  ```

- **`string` has no `length` property**; need to convert to `bytes` to check `length`.

  ```solidity
  contract MyContract {
    string str = "foo";

    function MyContract() {
      assert(size(str) == 3);
    }

    function size(string s) returns (uint) {
      return bytes(s).length;
    }
  }
  ```

- **Can't pass array of `string`s as argument to `external` function (from web3)**; need to do manual serializing and deserializing.

- **Can't typcast `address` to `string`**; need to manually convert using `bytes`.

  ```solidity
  contract MyContract {
    string public str;

    function MyContract() {
      str = toString(msg.sender);
    }

    function toString(address addr) returns (string) {
      bytes memory b = new bytes(20);
      for (uint i = 0; i < 20; i++)
      b[i] = byte(uint8(uint(addr) / (2**(8*(19 - i)))));
      return string(b);
    }
  }
  ```

- **Can't typecast `bytes` to `string`**; need to do manual conversion.

    ```
    contract MyContract {
      bytes32 bts = "foo";
      string str;

      function MyContract() {
        str = bytes32ToString(bts);
      }

      function bytes32ToString(bytes32 x) constant returns (string) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
          byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
          if (char != 0) {
            bytesString[charCount] = char;
            charCount++;
          }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
          bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
      }
    }
    ```

    The helper library [solidity-stringutils](https://github.com/Arachnid/solidity-stringutils) has more string typecasting examples.

- **Using `var`, the type is only deduced from the first assignment**; so this can be dangerous in certain scenarios where it's initialized to a smaller data type then expected, causing undesired consequences, like the following:

    ```solidity
    contract MyContract {
      function loop() {
        /* `i` will have max a max value of 255 (initialized as uint8),
         * causing an infinite loop.
         */
        for (var i = 0; i < 1000; i++) {

        }
      }
    }
    ```

    It's best practice to use an explicit type.

- **`uint` is alias to `uint256`**.

- **`byte` is alias to `bytes1`**.

- **`sha3` is alias to `keccak256`**.

- **`now` is alias to `block.timestamp`**.

- **`bytes` is the same `byte[]` but packed tightly (more expensive)**.

- **`string` is the same as `bytes` but doesn't allow length or index access**.

- **`public` vs `external` vs `internal` vs `private`**

   - `external`: function is part of the contract interface, which means it can be called from other contracts and via transactions. External functions are sometimes more efficient when they receive large arrays of data. Use external if you expect that the function will only ever be called externally. For external functions, the compiler doesn't need to allow internal calls, and so it allows arguments to be read directly from calldata, saving the copying step, which will save more gas.

    - `public`: function can either be called internally or externally. For public state variables, an automatic getter function is generated.

    - `internal`: function or state variables can only be accessed internally (i.e. from within the current contract or contracts deriving from it), without using `this`.

    - `private`: function or state variable is only visible for the contract they are defined in and not in derived contracts.

- **`msg.sender` is the contract caller**; (aka contract creator if in the constructor).

- **There's a limit to how many variables can be in a function**; this includes parameter and return variables. The limit is *16* variables, otherwise you get the `StackTooDeepException` error *"Internal compiler error: Stack too deep, try removing local variables."*.

    However if you need that many variables, then *you're probably doing something wrong*. You can break up the function into smaller functions, and set global variables to public to generate getters.

- **Solidity compiles the `enum` variable type down to an `int8`**; (unless the enum has more than 8 options, in which case it walks up the int type scale).

  ```solidity
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
  ```

- **You have to use `new` keyword for creating variable length in-memory arrays**. As opposed to storage arrays, it's not possible to resize memory arrays by assigning to the `length` member.

  ```solidity
  contract MyContract {
    uint[] foo;

    function MyContract() {
      uint[] memory bar = new uint[](5);
      bytes memory qux = new bytes(5);

      // dynamically resize storage array
      foo.length = 6;
      foo[5] = 1;
      assert(foo[5] == 1);

      // doesn't work, will throw
      bar.length = 6;
      qux.length = 6;
    }
  }
  ```

- **The type of an array literal is a memory array of fixed size whose base type is the common type of the given elements**; e.g. the type of `[1, 2, 3]` is `uint8[3]` memory, because the type of each of these constants is `uint8`. Fixed size memory arrays can't be assigned to dynamically-sized memory arrays, e.g. the following is not possible:

  ```solidity
  contract MyContract {
    function MyContract() {
      /* This creates a `TypeError` because uint8[3] memory
       * can't be converted to uint256[] memory.
       */
      uint[3] memory x = [1, 2, 3];

      // This works, because it's the same common type.
      uint8[3] memory y = [1, 2, 3];

      // This works, because it's the same common type.
      uint16[3] memory z = [256, 2, 3];
    }
  }
  ```

- **Declaring a local array and assuming it'll be created in memory but it actually overwrites storage**; e.g. the type of the local variable `x` is `uint[]` storage, but it has to be assigned from a state variable before it can be used because storage is not dynamically allocated, so it functions only as an alias for a pre-existing variable in storage. What happens is that the compiler interprets `x` as a storage pointer and will make it point to the storage slot `0` by default, which in this case is variable `foo`, and is modified by `x.push(1)` causing an error.

  ```solidity
  contract MyContract {
    uint foo;
    uint[] bar;

    // This will not work!
    function MyContract() {
      uint[] x;
      x.push(1);
      bar = x;
    }
  }
  ```

  do this instead:

  ```solidity
  contract MyContract() {
    uint foo;
    uint[] bar;

    function MyContract() {
      uint[] memory x = new uint[](5);
      x[0] = 1;
      bar = x;

      assert(foo == 0);
      assert(bar[0] == 1);
    }
  }
  ```

- **Solidity inherits scoping rules from JavaScript**; a variable declared anywhere within a function will be in scope for the entire function, rather than block scope.

    ```solidity
    contract MyContract {
      function MyContract() {
        uint i = 0;

        while (i++ < 1) {
          uint foo = 0;
        }

        while (i++ < 2) {
          // Illegal, second declaration of variable.
          uint foo = 0;
        }
      }
    }
    ```

    ```solidity
    contract MyContract {
      function MyContract() {
        for (uint i = 0; i < 1; i ++) {

        }

        // Illegal, second declaration of variable.
        for (uint i = 0; i < 1; i++) {

        }
      }
    }
    ```

- **Exceptions consume all the gas.**

- **Calls to external functions can fail, so always check return value**; like when using `send()`.

- **Use `transfer()` instead of `send()`**; `transfer()` is equivalent of `require(x.send(y))` (will throw if not successful).

    There are some dangers in using send: The transfer fails if the call stack depth is at 1024 (this can always be forced by the caller) and it also fails if the recipient runs out of gas.

    A better solution is to use the pattern where the recipient withdraws the money.

- **Calls are limited to a depth of 1024**; which means that for more complex operations, loops should be preferred over recursive calls.

- **Have to declare the source file compiler version at the top of the contract file**; the `^` means to use the latest patch release (0.4.x), so it uses the most update to date version without any breaking changes.

  ```solidity
  pragma solidity ^0.4.4;

  contract MyContract {

  }
  ```

- **All primitive data types are initialized with default values**; there is no "null" data type (like in JavaScript).

  ```solidity
  contract MyContract {
    int n; // 0
    string str; // ""
    address addr; // 0x0000000000000000000000000000000000000000
    bool b; // false
  }
  ```

- **Suffixes like seconds, minutes, hours, days, weeks and years after literal numbers can be used to convert between units of time**, where seconds are the base unit and units are considered naively in the following way:

    ```solidity
    contract MyContract {
      function MyContract() {
        assert(1 == 1 seconds);
        assert(1 minutes == 60 seconds);
        assert(1 hours == 60 minutes);
        assert(1 days == 24 hours);
        assert(1 weeks == 7 days);
        assert(1 years == 365 days);
      }
    }
    ```

    Take care if you perform calendar calculations using these units, because not every year equals 365 days and not even every day has 24 hours because of leap seconds. Due to the fact that leap seconds cannot be predicted, an exact calendar library has to be updated by an external oracle.

- **Date suffixes can't be applied to variables**; here's how you can interpret some input variable in, e.g days:

    ```solidity
    contract MyContract {
      function hasStarted(uint start, uint daysAfter) returns (bool) {
        return (now >= start + daysAfter * 1 days);
      }
    }
    ```

- **Generating random numbers is hard;** because Ethereum a deterministic system. You can generate a "random" number based on the block hash and block number, but keep in mind that miners have influence on these values.

    ```solidity
    contract MyContract {
      function rand(uint min, uint max) public returns (uint) {
        return uint(block.blockhash(block.number-1))%(min+max)-min;
      }
    }
    ```

- **Use `indexed` for events parameters**; it allows you to search for the events using the indexed parameters as filters.

  ```solidity
  contract MyContract {
    event Transfer(address indexed sender, address indexed recipient, uint256 amount);
  }
  ```

  ```javascript
  // Filter by indexed parameter.
  myContract.events.Transfer({sender: '0x123...abc'}, (error, events) => {})

  /* Can't filter by un-indexed parameter,
   * so this won't work.
   */
  myContract.events.Transfer({amount: 1}, (error, events) => {})
  ```

- **Only up to three parameters can receive the attribute `indexed` for event parameters.**

- **You can specify named output parameters in `returns` signature which creates new local variables.**

  ```solidity
  contract MyContract {
    function MyContract() {
      assert(myMethod() == 10);
    }

    function myMethod() returns (uint num) {
      num = 10;
      return num;
    }
  }
  ```

- **Contracts can't activate themselves**; they need a "poke", e.g. a contract can't automatically do something when it reaches a certain block number (like a cron job). There needs to be a call from the outside for the contract to do something; an external poke.

# Eamples

Example code available in [`contracts/`](./contracts/) directory.

# Contributing

Pull requests are always welcomed for explaining or showing a solidity feature that is not intuitive.

# Issues

Ethereum and Solidity are quickly evolving so some things may no longer be relevant in the future.

Please submit an issue or make a pull request if something in incorrect.

# Resources

- [Solidity](https://github.com/ethereum/solidity)

- [Truffle](https://github.com/trufflesuite/truffle)

- [Smart Contract Best Practices](https://github.com/ConsenSys/smart-contract-best-practices)

- [Solidity Baby Steps](https://github.com/fivedogit/solidity-baby-steps)

- [Ethereum Stack Exchange](https://ethereum.stackexchange.com/)

# License

MIT

