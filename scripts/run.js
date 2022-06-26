const validBoard = [1,5,3,7,3,7,1,5,5,1,7,3,7,3,5,1]; 
const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('Game');
    const gameContract = await gameContractFactory.deploy();
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);

    let txn = await gameContract.setInitialState();
    await txn.wait();

    // let state = await gameContract.getInitialState(); 
    // console.log(state)

    let state = await gameContract.temp(); 
    console.log(state)

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

