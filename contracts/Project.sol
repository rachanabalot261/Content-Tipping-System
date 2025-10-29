// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Content Tipping System
/// @notice Allows users to tip content creators with Ether.
contract Project {
    uint256 public totalTips;
    uint256 private nextTipId = 1;

    struct Tip {
        uint256 id;
        address sender;
        address receiver;
        string contentId; // e.g., YouTube video ID, blog post URL, etc.
        uint256 amount;
        uint256 timestamp;
        string message;
    }

    mapping(uint256 => Tip) private tips;
    mapping(address => uint256[]) private tipsReceivedByUser;

    event TipSent(
        uint256 indexed id,
        address indexed sender,
        address indexed receiver,
        string contentId,
        uint256 amount,
        string message
    );

    /// @notice Send a tip to a content creator.
    /// @param receiver Address of the content creator.
    /// @param contentId ID or URL of the content being tipped.
    /// @param message Optional short message from sender.
    function sendTip(address payable receiver, string calldata contentId, string calldata message) 
        external 
        payable 
    {
        require(msg.value > 0, "Tip amount must be greater than zero");
        require(receiver != address(0), "Invalid receiver address");
        require(receiver != msg.sender, "You cannot tip yourself");

        uint256 tipId = nextTipId++;
        totalTips += msg.value;

        tips[tipId] = Tip({
            id: tipId,
            sender: msg.sender,
            receiver: receiver,
            contentId: contentId,
            amount: msg.value,
            timestamp: block.timestamp,
            message: message
        });

        tipsReceivedByUser[receiver].push(tipId);

        // Transfer tip
        receiver.transfer(msg.value);

        emit TipSent(tipId, msg.sender, receiver, contentId, msg.value, message);
    }

    /// @notice Get details of a specific tip.
    function getTip(uint256 id)
        external
        view
        returns (
            uint256,
            address,
            address,
            string memory,
            uint256,
            uint256,
            string memory
        )
    {
        require(id > 0 && id < nextTipId, "Invalid tip ID");
        Tip storage t = tips[id];
        return (t.id, t.sender, t.receiver, t.contentId, t.amount, t.timestamp, t.message);
    }

    /// @notice Get all tip IDs received by a user.
    function getTipsReceivedByUser(address user) external view returns (uint256[] memory) {
        return tipsReceivedByUser[user];
    }
}



