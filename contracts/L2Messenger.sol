// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract L2Messenger {
    address public l2Contract;

    constructor(address _l2Contract) {
        l2Contract = _l2Contract;
    }

    function setL2Contract(address _l2Contract) external {
        require(l2Contract == address(0), "L2 contract already set");
        l2Contract = _l2Contract;
    }

    function sendMessage(address _recipient, bytes memory _message) public {
        // Ensure that only the L2 contract can call this function
        require(msg.sender == l2Contract, "Only L2 contract can call");

        // Send the message to the recipient contract
        (bool success, ) = _recipient.call(_message);

        // Check if the call was successful
        require(success, "Message sending failed");

        // Optional: Use returnData for further processing if needed
    }
}
