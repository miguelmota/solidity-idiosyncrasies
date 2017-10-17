pragma solidity ^0.4.4;

// Source: https://ethereum.stackexchange.com/a/2834/5093

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

  function bytes32ArrayToString(bytes32[] data) returns (string) {
    bytes memory bytesString = new bytes(data.length * 32);
    uint urlLength;
    for (uint i=0; i<data.length; i++) {
      for (uint j=0; j<32; j++) {
        byte char = byte(bytes32(uint(data[i]) * 2 ** (8 * j)));
        if (char != 0) {
          bytesString[urlLength] = char;
          urlLength += 1;
        }
      }
    }
    bytes memory bytesStringTrimmed = new bytes(urlLength);
    for (i=0; i<urlLength; i++) {
      bytesStringTrimmed[i] = bytesString[i];
    }
    return string(bytesStringTrimmed);
  }
}
