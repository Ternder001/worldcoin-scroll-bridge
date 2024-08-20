// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract OpWorldID {
    address public l2Messenger;
    bytes32 public currentRoot; // Stores the latest valid root
    mapping(bytes32 => bool) public rootHistory; // Tracks all received roots

    event RootUpdated(bytes32 indexed newRoot, uint256 timestamp);

    constructor(address _l2Messenger) {
        l2Messenger = _l2Messenger;
    }

    function setL2Messenger(address _l2Messenger) external {
        require(l2Messenger == address(0), "L2 Messenger already set");
        l2Messenger = _l2Messenger;
    }

    function receiveLatestRoot(bytes32 _latestRoot) public {
        // Ensure that only the L2 messenger can call this function
        require(msg.sender == l2Messenger, "Only L2 messenger can call");

        // Logic to process the latest root:

        // Check if the root has been processed before
        require(!rootHistory[_latestRoot], "Root has already been processed");

        // Update the currentRoot with the latest root
        currentRoot = _latestRoot;

        // Mark the root as processed
        rootHistory[_latestRoot] = true;

        // Emit an event to notify about the root update
        emit RootUpdated(_latestRoot, block.timestamp);

        // Additional processing can be added here, such as validation or triggering other actions
    }

    function receiveMessage(bytes memory _message) public {
        // Ensure that only the L2 messenger can call this function
        require(msg.sender == l2Messenger, "Only L2 messenger can call");

        // Decode the latest root from the message
        bytes32 latestRoot = abi.decode(_message, (bytes32));

        // Call the receiveLatestRoot function with the decoded root
        receiveLatestRoot(latestRoot);
    }
}
