// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IWorldIDIdentityManager {
    function latestRoot() external view returns (bytes32);
}
