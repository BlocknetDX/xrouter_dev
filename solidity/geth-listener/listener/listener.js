const Web3 = require('web3')

const web3 = new Web3(new Web3.providers.WebsocketProvider('http://127.0.0.1:8545'));

console.log(web3.version)

web3.eth.isSyncing().then(console.log);

const abi = require('./ERC20.json')
//GNT4 on ropsten
const contract = new web3.eth.Contract(abi, '0x219DaB9993AAcf345B25D89AA5ACa639CC70e65d')

setInterval(function() {
  contract.getPastEvents('allEvents', {fromBlock: 0, toBlock: 'latest'},
    function(error, events){
      if(error)
      {
        console.log(error);
      }
      console.log(events); 
    }
  )
},1000)
