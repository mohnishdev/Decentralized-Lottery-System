// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";


/**
 * @title A sample Raffle Contract
 * @author Mohnish Sharma
 * @notice This contract is for creating simple lottery system called Raffle
 */

contract Raffle {

    error Raffle__notEnoughEthSent();

    // State variables

    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDs = 1;


    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval; // Duration of lottery in second
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;
    uint32 private i_callbackGasLimit ;


    /** Events */

    event EnteredRaffle(address indexed player);

    constructor(uint256 entranceFee , uint256 interval , address vrfCoordinator , bytes32 gasLane , uint64 subscriptionId ,  uint32 callbackGasLimit){
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        s_lastTimeStamp = block.timestamp;
        i_callbackGasLimit = callbackGasLimit;
    }

    function enterRaffle() public payable{
        if(msg.value < i_entranceFee){
            revert Raffle__notEnoughEthSent();
        }
        s_players.push(payable(msg.sender));
        emit EnteredRaffle(msg.sender);

    }

    function pickWinner() external {
        // check to see if enough time is passed 
       if(block.timestamp - s_lastTimeStamp > i_interval){
        revert();
       }

       uint256 requestId = i_vrfCoordinator.requestRandomWords(
        i_gasLane, // gas lane
        i_subscriptionId,
        REQUEST_CONFIRMATIONS,
        i_callbackGasLimit,
        NUM_WORDs
       );

    //    
    }

    function getEntranceFee() external view returns (uint256){
        return i_entranceFee;
    }
}