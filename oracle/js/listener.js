let lastBlock = 0
let newQueries = []
setInterval(async function() {
    newQueries = []
  await contract.getPastEvents('allEvents', {fromBlock: lastBlock, toBlock: 'latest'},
    function(error, events){
      if(error){
        console.log(error)
      }
      if(events){
        console.log(events);
        if(events.length > 0){
            lastBlock = events[events.length - 1].blocknumber
            foreach(let e of events){
                if(e.event == "queried"){
                    newQueries.push(e)
                }
            }
        }
        return newQueries
      }
    }
  )
},10000)


