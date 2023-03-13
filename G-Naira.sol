/*
 *  How to use the multi-signature feature

 *  First deploy contract with your address, this address is now the owner and the GOVERNOR
 *  Now GOVERNOR can add DELEGATES addresses using the "setDelegates" function 

 *  (Hardcoded at line 33: only 2 approvals are needed before GOVERNOR can mint/ burn, 
 *   you can change the number of DELEGATES needed using "setRequiredApproval") 

 *  Connect wallet as DELEGATE addresses to interact with the contract,
 *  one by one your DELEGATES should click on "incrementApproval" function,
 *  when a DELEGATE does this, 1 approval will be added, other DELEGATES need to do this to increase approval for GOVERNOR
 *  Only when atleast 2 delegates approve, can the governor burn or mint
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; //I imported like this because I am making use of Remix IDE
import "@openzeppelin/contracts/access/AccessControl.sol"; 

//Inherite from the Openzeppelin contract
contract GNaira is ERC20, AccessControl {

     // Create a new role identifier for the restricted routes (Access control)
    bytes32 public constant GOVERNOR = keccak256("GOVERNOR"); 
    bytes32 public constant DELEGATE_ROLE = keccak256("DELEGATE_ROLE");


    address owner; 
    mapping(address => bool) private blacklist; //mapping for blacklisted addresses
    uint256 approvalCount; //variable for verification of approval
    uint256 requiredApproval = 2; //The governor only needs two delegates approval to mint and burn

    //constructor function for the contract
    constructor() ERC20("G-Naira", "gNGN") { //currency's name, currency's symbol
          owner = msg.sender; // owner is the deployer of the contract
         _setupRole(GOVERNOR, msg.sender); //The role of governor is set to owner
        _mint(msg.sender, 1000 * 10 ** decimals()); //Hardcoding the initialSupply of currency to deployer
    }

    //This checks if approval threshold is met i.e determines if the governor can burn or mint
    modifier isApproved () {
        require(approvalCount == requiredApproval, "Approval requirement not reached");
        _;
    } 

    //Governor can set the number of required delegates needed for approval
    function setRequiredApproval (uint256 _count) onlyRole(GOVERNOR) public  {
        requiredApproval = _count;
    } 

    //Governor can blacklists users 
    function blacklistAddress(address _badUser) public onlyRole(GOVERNOR) {
        blacklist[_badUser] = true;
    }

    //Governor can also remove blacklisted users 
    function unBlacklistAddress(address _badUser) public onlyRole(GOVERNOR) {
        blacklist[_badUser] = false;
    }

    //Checks if a user is blacklisted or not
    function blacklistCheck(address userAddress) public view returns(bool){
        return blacklist[userAddress];
    }

    //Governor can add delegates
    function setDelegates (address _delegate) public onlyRole(GOVERNOR) {
        require(_delegate != address(0));
        _setupRole(DELEGATE_ROLE, _delegate);
    }

    //Only delegates can increment approval count, even the governor cannot do this 
    function incrementApproval () public onlyRole(DELEGATE_ROLE) {
        approvalCount+= 1;
    }

    //Governor can mint if approved count is reached
    function mint(address _to, uint256 _amount) public isApproved onlyRole(GOVERNOR)  {
        _mint(_to, _amount);
    }

    //Governor can burn if approved count is reached
    function burn (uint256 _amount) public isApproved onlyRole(GOVERNOR) {
        _burn (owner, _amount);
    }


    //Checks if users address is blacklisted before transaction
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        override
    {
        require(blacklistCheck(from) == false, "Sender is blacklisted");
        require(blacklistCheck(to) == false, "Reciever is blacklisted");

        super._beforeTokenTransfer(from, to, amount);
    }

     
}
