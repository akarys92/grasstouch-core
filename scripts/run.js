const validBoard = [1,3,7,5,5,7,3,1,3,5,1,7,7,1,5,3];
const main = async () => {
    const Game = await ethers.getContractFactory("Game");
    const game = await Game.deploy();
    await game.deployed();
    console.log("Contract deployed to:", game.address);

    let state = await game.getState(); 
    console.log(state);

    let txn = await game.verifySolution(validBoard, {gasLimit: 3000000}); 
    await txn.wait(); 

};

const runMain = async () => {
try {
    await main();
    process.exit(0);
} catch (error) {
    console.log(error);
    process.exit(1);
}
};

runMain();

