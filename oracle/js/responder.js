async function respond(response){
    let tx = await contract.methods.callback(0, 0, response)
    .send({from: web3.accounts[0]}).catch((err) => {console.error(err);});
    console.log(response);
}

respond(process.argv.slice(2));
