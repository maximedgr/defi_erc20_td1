var ExerciceSolution = artifacts.require("ExerciceSolution.sol");
var ExerciceSolutionToken = artifacts.require("ExerciceSolutionToken.sol");


module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        await deployExerciceSolution(deployer, network, accounts);
        await deployExerciceSolutionToken(deployer, network, accounts);
        await deployRecap(deployer, network, accounts); 
    });
};

async function deployExerciceSolutionToken(deployer, network, accounts) {
	ExerciceSolutionToken = await ExerciceSolutionToken.new(ExerciceSolution.address,{from: accounts[0]});
}
async function deployExerciceSolution(deployer, network, accounts) {
	ExerciceSolution = await ExerciceSolution.new("0x16F3F705825294A55d40D3D34BAF9F91722d6143","0xE70AE39bDaB3c3Df5225E03032D31301E2E71B6b",{from: accounts[0]});
}


async function deployRecap(deployer, network, accounts) {
	console.log("ExericeSolution " + ExerciceSolution.address)
    console.log("ExericeSolutionToken " + ExerciceSolutionToken.address)
}

//Nb : truffle migrate --f 2 --to 2 --network goerli