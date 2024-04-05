// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Lottery {
    address public lastWinner;
    address public manager;
    address[] public players;

    constructor(){
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value >= .01 ether);

        players.push(msg.sender);
    }

    function pickWinner() public restricted{
        uint index = random() % players.length; // generates random uint number
        address payable winner = payable(players[index]); // needs to specify that this address is payable
        winner.transfer(address(this).balance);
        lastWinner = players[index];
        players = new address[](0); // initialize players array 
    }

    function getPlayers() public view returns (address[] memory){
        return players;
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players))); // we can after deconstruct this "encoded" number - block.difficulty, block.timestamp, players
    }

    modifier restricted(){
        require(msg.sender == manager);
        _;
    }
}