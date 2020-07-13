var solrouter = artifacts.require("./solrouter.sol");
var solrouterUser = artifacts.require("./solrouterUserEx.sol");

contract("solrouter test", async function(accounts) {
    it("testing ethbtc price update in solrouterUser contract", async function() {
        let sr = await solrouter.deployed();
        let sru = await solrouterUser.deployed();

        await sru.setSRA(sr.address);
        console.log(sr.address);
        console.log(await sru.solrouterAddress());

        let price = await sr.requestPrice({ from: accounts[0] });
        console.log("price", price);

        let blockreq = await sru.updateEthbtc({ from: accounts[0] });
        console.log("query blocknet gas used", blockreq.receipt.gasUsed);

        await sr.callback(0, 1, "100", { from: accounts[0] });
        console.log("data sent");

        console.log(await sru.ethbtc({ from: accounts[0] }));
        assert.equal(await sru.ethbtc({ from: accounts[0] }), "100");
    });
});

