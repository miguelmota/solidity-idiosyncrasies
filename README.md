# Solidity Idiosyncrasies

> [Solidity](https://github.com/ethereum/solidity) gotchas, pitfalls, limitations, and idiosyncrasies.

This is a list of things that have caused me to bang my head against a brick wall when coming across them in solidity.

---

In no particular order:

- Can't return `struct` for `external` methods; need to return multiple values.

  ```solidity
  contract MyContract {
    struct MyStruct {
      uint foo;
      string bar;
    }

    MyStruct myStruct;

    function MyContract() {
      myStruct = MyStruct(10, "hello");
    }

    function myMethod() returns (uint, string) {
      return (myStruct.foo, myStruct.bar);
    }
  }
  ```

- Can't splice an array; need to do it manually and update `length`.

- Using `delete` on an array leaves a gap. Need to shift items and update `length`.

  ```solidity
  contract MyContract {
    uint[] array = [1,2,3];

    function removeAtIndex(uint index) returns(uint[]) {
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

- Can't typecast to `string`. The helper library [solidity-stringutils](https://github.com/Arachnid/solidity-stringutils) can help.

- Can't compare two `string`s; one workaround is to compare the `sha3` hashes of the strings.

  ```solidity
  contract MyContract {
    function compare(string s1, string s2) returns(bool) {
      return (sha3(s1) == sha3(s2));
    }
  }
  ```

  or compare `byte` by `byte`. The helper library [solidity-stringutils](https://github.com/Arachnid/solidity-stringutils) has good examples.

- Can't check `string` `length`; need to convert to `bytes` to check `length`.

  ```solidity
  contract MyContract {
    string str = "foo";

    function MyContract() {
      assert(size(str) == 3);
    }

    function size(string s) returns(uint) {
      return bytes(s).length;
    }
  }
  ```

- Can't pass array of `string`s as argument to `external` function; need to do manual serializing and deserializing.

- Can't typcast `address` to `string`; need to manually convert using `bytes`.

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

- Can't typecast `bytes` to `string`; need to do manual conversion.

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

- `uint` is alias to `uint256`.

- `bytes` is alias to `bytes32`.

- `public` vs `external` vs `internal` vs `private`

   - `external`: function is part of the contract interface, which means it can be called from other contracts and via transactions. External functions are sometimes more efficient when they receive large arrays of data. Use external if you expect that the function will only ever be called externally. For external functions, the compiler doesn't need to allow internal calls, and so it allows arguments to be read directly from calldata, saving the copying step, which will save more gas.

    - `public`: function can either be called internally or externally. For public state variables, an automatic getter function is generated.

    - `internal`: function or state variables can only be accessed internally (i.e. from within the current contract or contracts deriving from it), without using `this`.

    - `private`: function or state variable is only visible for the contract they are defined in and not in derived contracts.

# Eamples

Example code available in [`contracts/`](./contracts/) directory.

# License

MIT

