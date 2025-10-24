// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TippingSystem {
    address payable public owner;
    bool public paused = false;

    mapping(address => bool) public isCreator;

    event CreatorRegistered(address indexed creator);
    event TipReceived(address indexed tipper, address indexed creator, uint256 amount);
    event TippingPaused(address indexed admin);
    event TippingUnpaused(address indexed admin);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Tipping is currently paused.");
        _;
    }

    constructor() {
        owner = payable(msg.sender);
    }

    function pauseTipping() public onlyOwner {
        require(!paused, "Tipping is already paused.");
        paused = true;
        emit TippingPaused(msg.sender);
    }

    function unpauseTipping() public onlyOwner {
        require(paused, "Tipping is not paused.");
        paused = false;
        emit TippingUnpaused(msg.sender);
    }

    function registerAsCreator() public {
        require(!isCreator[msg.sender], "You are already a registered creator.");
        isCreator[msg.sender] = true;
        emit CreatorRegistered(msg.sender);
    }

    function tipCreator(address payable _creator) public payable whenNotPaused {
        require(isCreator[_creator], "Recipient is not a registered creator.");
        require(msg.value > 0, "Tip must be greater than 0 Ether.");
        require(_creator != msg.sender, "Cannot tip yourself.");

        (bool success, ) = _creator.call{value: msg.value}("");
        require(success, "Ether transfer failed.");

        emit TipReceived(msg.sender, _creator, msg.value);
    }

    function ownerWithdrawal() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No Ether balance in contract to withdraw.");
        (bool success, ) = owner.call{value: balance}("");
        require(success, "Owner withdrawal failed.");
    }
}

