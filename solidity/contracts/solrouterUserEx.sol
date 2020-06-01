pragma solidity ^0.6.8;

contract solrouterUserEx{
    
    string public ethbtc; //updated by snode_callback
    
    address owner;
    address payable public solrouterAddress;
    //solrouterAbstract public sra;

    constructor () public {
        owner = msg.sender;
    }
    
    function setSRA(address payable newSRA) public {
        require(msg.sender == owner);
        solrouterAddress = newSRA;
		//sra = solrouterAbstract(newSRA);
    }
    
    function updateEthbtc() public payable{
        //solrouterAddress.transfer(msg.value);
		//solrouterAbstract sra =  
        solrouterAddress.call.value(msg.value)(abi.encodeWithSignature("query(string)", "requestString"));
    }
    
    function snode_callback(string memory data) public {
        require(msg.sender == solrouterAddress, "Invalid data provider");
        ethbtc = data;
    }
}