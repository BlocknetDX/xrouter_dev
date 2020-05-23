pragma solidity ^0.6.8;

contract solrouter
{
    //storage
    uint32 lastSnodeID;
    uint64 lastRequestID;
    uint256 public requestPrice = 1 finney;
    
    mapping(address => bool) snodeNominations; //snode address to nominated
    mapping(uint32 => address) snodes; //snode ID to snode address
    mapping(uint64 => address) requests; //request ID to requesting contract address
    mapping(address => uint256) payments; //user address to payments
    mapping(address => uint256) snodeBalance; //snode address to reward balance
    
    //init
    constructor () public {
        snodes[0] = msg.sender;
    }
    
    //events
    event queried(address indexed sender, string indexed request, uint timestamp);
    event successfulCallback(uint32 indexed snodeID, uint64 indexed requestID, string requestReturn);
    
    //Snode registration
    function nominateSnode(address newSnode, uint32 myID) public {
        require(snodes[myID] == msg.sender, "Nominator is not a registered snode");
        snodeNominations[newSnode] = true;
    }
    
    function registerSnode() public {
        require(snodeNominations[msg.sender], "Snode is not nominated");
        lastSnodeID++;
        snodes[lastSnodeID] = msg.sender;
    }
    
    //User query
    receive() external payable {
        payments[msg.sender] = msg.value;
    }
    
    function query(string memory request) public {
        lastRequestID++;
        require(payments[msg.sender] >= requestPrice, "Insufficient payment for request");
        
        requests[lastRequestID] = msg.sender;
        
        emit queried(msg.sender, request, block.timestamp);
    }
    
    //Snode callback portal
    function callback(uint32 snodeID, uint64 requestID, string memory requestReturn) public  returns (string memory){
        
        require(snodes[snodeID] == msg.sender, "Snode ID does not match sender");
        //enter user's contract at function snode_callback(string)
        (bool success, bytes memory data) = requests[requestID].call(abi.encodeWithSignature("snode_callback(string)", requestReturn)); 
        require(success, "Callback failed");
        //pay snode for successfully providing data
        snodeBalance[msg.sender] += requestPrice; 
        payments[requests[requestID]] -= requestPrice;
        emit successfulCallback(snodeID, requestID, requestReturn);
        return (string(data));
    }
    
    //Snode admin
    function withdraw() public payable{
        require(snodeBalance[msg.sender] > 0, "Sender has no balance");
        msg.sender.transfer(snodeBalance[msg.sender]);
    }
}