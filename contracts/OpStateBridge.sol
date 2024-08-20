// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface WorldIDIdentityManager {
    function latestRoot() external view returns (bytes32);
}

interface L1Messenger {
    function sendMessage(address _l2Contract, bytes memory _message) external;
}

contract OpStateBridge {
    address public worldIDManager;
    address public l1Messenger;
    address public l2Contract;
    address public targetL2Contract;

    constructor(
        address _worldIDManager,
        address _l1Messenger,
        address _l2Contract
    ) {
        worldIDManager = _worldIDManager;
        l1Messenger = _l1Messenger;
        l2Contract = _l2Contract;
    }

    function setTargetL2Contract(address _targetL2Contract) external {
        require(
            targetL2Contract == address(0),
            "Target L2 contract already set"
        );
        targetL2Contract = _targetL2Contract;
    }

    function fetchAndSendLatestRoot() public {
        // Fetch the latest root from the WorldIDIdentityManager contract
        bytes32 latestRoot = WorldIDIdentityManager(worldIDManager)
            .latestRoot();

        // Encode the latest root to send to L2
        bytes memory message = abi.encode(latestRoot);

        // Use the L1 messenger to send the message to the L2 contract
        L1Messenger(l1Messenger).sendMessage(l2Contract, message);
    }
}
