pragma solidity ^0.4.4;

contract MyContract {
  function MyContract() {
    assert(1 == 1 seconds);
    assert(1 minutes == 60 seconds);
    assert(1 hours == 60 minutes);
    assert(1 days == 24 hours);
    assert(1 weeks == 7 days);
    assert(1 years == 365 days);
  }

  function hasStarted(uint start, uint daysAfter) returns (bool) {
    return (now >= start + daysAfter * 1 days);
  }
}
