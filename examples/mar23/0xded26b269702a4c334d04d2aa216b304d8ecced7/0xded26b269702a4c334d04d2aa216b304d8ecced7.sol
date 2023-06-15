contract ContractMint {

    address private  owner;

     constructor() {   
        owner=msg.sender;
    }
    function getOwner(
    ) public view returns (address) {    
        return owner;
    }
    function withdraw() public {
        require(owner == msg.sender);      
        payable(msg.sender).transfer(address(this).balance);
    }

    function Mint() public payable {
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}