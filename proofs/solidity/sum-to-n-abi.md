pragma solidity ^0.4.0;
contract SumToNContract {
    function sumToN(uint256 n) public constant returns (uint256 sum) {
        sum = (n * (n + 1)) / 2;
    }
}
