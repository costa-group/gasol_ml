// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "Clones.sol";
import "Raffle.sol";

contract RaffleClone {
    
    address immutable raffleImplementation;
    address[] public raffleArray;
    address public owner;
    address public developer;
    address public  rngesusContract;
    

    struct RaffleCreator {
        bool isRaffleCreator;
    }

    mapping(address => RaffleCreator) public raffleCreators;

    event raffleImplementationEvent(address);
    event newRaffleCreated(address);

    constructor(address _developer, address _rngesusContract) {

        // set the owner and make the owner a raffleCreator
        owner = msg.sender;
        raffleCreators[msg.sender].isRaffleCreator = true;
        developer = _developer;
        rngesusContract = _rngesusContract;
        
        // set the address of the implementation contract and emit event
        raffleImplementation = address(new Raffle());
        emit raffleImplementationEvent(raffleImplementation);
    }

    // create a new raffle
    function createRaffle (
        string memory _raffleName,
        uint256 _ticketPrice, 
        uint256 _totalTickets, 
        address _raffleCreator,  // need to transfer the nft to the raffle
        address[] memory _feeAddresses,  // addresses that will receive the funds of ticket sales
        uint256[] memory _feePercentages, // distribution of the funds, the sum should always be 100
        uint256 _durationDays,
        uint256 _maxTicketsPerWallet,
        address _developer  // the developer can execute the fail safe and set the contract to CLAIM_REFUND

        ) public {

            require(raffleCreators[msg.sender].isRaffleCreator == true, "You can't create Raffles.");

            // clone the raffle implementation and emit event
            address newRaffleAddress = Clones.clone(raffleImplementation);
            raffleArray.push(newRaffleAddress);
            emit newRaffleCreated(newRaffleAddress);
            
            // initialize the raffle
            Raffle(newRaffleAddress).initialize(
                _raffleName, 
                _ticketPrice, 
                _totalTickets, 
                rngesusContract, 
                _raffleCreator, 
                _feeAddresses, 
                _feePercentages, 
                _durationDays, 
                _maxTicketsPerWallet, 
                _developer
            );

        }

    function removeRaffleCreator(address raffleCreator) public {

        require(owner == msg.sender, "You can't use this function");

        raffleCreators[raffleCreator].isRaffleCreator = false;
    }

    function addRaffleCreator(address raffleCreator) public {

        require(owner == msg.sender, "You can't use this function");

        raffleCreators[raffleCreator].isRaffleCreator = true;

    }

    function getRaffleArray() external view returns (address[] memory) {
        
        return raffleArray;
    
    }

    function setRngesusContract(address _rngesusContract) public {

        require(owner == msg.sender, "You can't use this function");
        rngesusContract = _rngesusContract;

    }

    function withdrawAll() public {

        require(owner == msg.sender, "You can't use this function");

        uint256 balance = address(this).balance;

        payable (msg.sender).transfer(balance);
    }

}