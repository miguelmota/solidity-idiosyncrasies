var SafeMath = artifacts.require('./SafeMath.sol')

contract('SafeMath', function(accounts) {
  it('should add correctly', async function() {
    const instance = await SafeMath.deployed()
    let a = 5678
    let b = 1234
    let add = await instance.safeAdd.call(a, b)

    assert.equal(add, a+b)
  })
})
