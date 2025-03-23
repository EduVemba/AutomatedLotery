// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import {Structs} from "./Structs.sol";

error notOwner();

contract Lotery {

    using Structs for Structs.Lotery;

    address public immutable owner;
    uint256 public constant entryFees = 5;
    uint256 public entryPrice;
    uint256 public gameReward;
    

    constructor() {
        owner = msg.sender;
    }

    modifier OnlyOwner(){
        if (msg.sender != owner) {
           revert notOwner();
        }
        _;
    }

    /**
     * mapping of address of users 
     */
    mapping(address => Structs.User) public UserMapping;
    mapping(address => uint256) public UserBalance; 

    /**
     * Array for players
     * 
     * @notice when a player join the Lotery he is added in the array
     */
    Structs.User[] public PlayingPlayers;
    
    Structs.Lotery[] public Loteries;

    uint256 internal _id = 1;

    address public CurrentWinner;

    /**
     * Events
     */
    event newLoteryOpen(uint256 indexed id, uint256 prize);

    /**
     * 
     */
    function createLotery(uint256 _entryPrice, uint256 _gameAward) external OnlyOwner returns (bool) {
        require(_gameAward > _entryPrice,"the award should be bigger then the entry");
        for (uint i = 0; i < Loteries.length; i++){
            if (Loteries[i].status == Structs.LoteryStatus.OPEN) {
                revert("There is a open lotery");
            }
        }

        entryPrice = _entryPrice;
        gameReward = _gameAward;

        Structs.Lotery memory newLotery = Structs.Lotery({
              id: _id,
              creator: msg.sender,
              price: entryPrice,
              players: PlayingPlayers,
              startTime: block.timestamp,
              reward: gameReward,
              status:  Structs.LoteryStatus.OPEN
        });

        Loteries.push(newLotery);
        emit newLoteryOpen(_id, gameReward);

        _id++;

        return true;
    }

    /**
     * 
     */
    function joinLotery() external {}
    
    
}