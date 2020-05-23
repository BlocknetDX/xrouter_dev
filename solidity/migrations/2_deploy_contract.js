var solrouter = artifacts.require("./solrouter.sol");
var solrouterUser = artifacts.require("./solrouterUserEx.sol");


module.exports = function(deployer) {
    deployer.then(async function () {
        await deployer.deploy(solrouter);
        await deployer.deploy(solrouterUser);
    });
}
