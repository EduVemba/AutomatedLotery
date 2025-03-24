// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import {Structs} from "./Structs.sol";
import { NoReentrant } from "./NonReentrant.sol";

error notOwner();

contract Lotery is NoReentrant {

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
    mapping(address => uint256) public UserBalance; 
    mapping(address => Structs.User) public UserInfo;

    /**
     * Array for players
     * 
     * @notice when a player join the Lotery he is added in the array
     */
    
    Structs.Lotery[] public Loteries;

    address[] public UsersPlaying;

    uint256 internal _id = 1;

    address public CurrentWinner;
    uint256 public WinningValue;
    Structs.Lotery public  OcurringLotery;

    /**
     * Events
     */
    event newLoteryOpen(uint256 indexed id, uint256 prize);
    event closedLotery(uint256 indexed id, uint256 time);
    event newUserEntered(address indexed user, uint256 amount);
    event userUpgraded(address indexed user, uint256 amount);

    /**
     * 
     */
    function createLotery(uint256 _entryPrice, uint256 _gameAward) external payable OnlyOwner NoReentrancy returns (bool) {
        require(_gameAward > _entryPrice,"the award should be bigger then the entry");
        require(msg.value >= _gameAward,"you must send enough ETH to fund the reward");

        for (uint i = 0; i < Loteries.length; i++){
            if (Loteries[i].status == Structs.LoteryStatus.OPEN) {
                revert("There is a open lotery");
            }
        }


        entryPrice = _entryPrice;
        gameReward = _gameAward;

      //  payable(address(this)).transfer(_gameAward);

        Structs.Lotery memory newLotery = Structs.Lotery({
              id: _id,
              creator: msg.sender,
              price: entryPrice,
              players_id: UsersPlaying,
             // players_info: PlayingPlayers,
              startTime: block.timestamp,
              reward: gameReward,
              status:  Structs.LoteryStatus.OPEN
        });

        OcurringLotery = newLotery;

        Loteries.push(newLotery);
        emit newLoteryOpen(_id, gameReward);

        _id++;

        return true;
    }

    /**
     * 
     */
    function joinLotery(string memory _name) external payable NoReentrancy returns (bool) {
        require(msg.value > WinningValue,"the value must be bigger then the winning value");

        bool isNewUser = true;

        for (uint i = 0; i < UsersPlaying.length; i++) {
            if (UsersPlaying[i] == msg.sender){
                UserBalance[msg.sender] += msg.value;
                UserInfo[msg.sender].value += msg.value;
                CurrentWinner = msg.sender;
                emit userUpgraded(msg.sender, msg.value);
                isNewUser = false;
                break;
            }
        }

    if (isNewUser) {
        Structs.User memory newUser = Structs.User({
              userAddress: msg.sender,
              value: msg.value,
              name: _name
        });
    
        CurrentWinner = msg.sender;
        UsersPlaying.push(msg.sender);
        UserBalance[msg.sender] = msg.value;
        UserInfo[msg.sender] = newUser;

        emit newUserEntered(msg.sender, msg.value);
    }

        if (msg.value > WinningValue) {
            WinningValue = msg.value;
            CurrentWinner = msg.sender;
        }

        return true;
    }

    // TODO: Ensure that only the Chainlink Automation trigger call this function

    function endLotery() public NoReentrancy returns (bool) {
       require(CurrentWinner != address(0),"no user to send");
      // require(address(this).balance > gameReward,"not enough money");

       OcurringLotery.status = Structs.LoteryStatus.CLOSED;

       (bool transferSuccess,) = payable(CurrentWinner).call{value: gameReward}("");
       require(transferSuccess,"something went wrong during the transfer");

       WinningValue = 0;
       CurrentWinner = address(0);

       emit closedLotery(OcurringLotery.id, block.timestamp);

       delete UsersPlaying;
    
      return true;
    }
    
    
}