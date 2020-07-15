async function respond(response){
    let tx = await contract.callback(0, response)
    .send({from: web3.accounts[0]})
    console.log(response);
}
