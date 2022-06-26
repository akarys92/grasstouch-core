const { expect } = require("chai");
const { ethers } = require("hardhat");

const validBoard = [1,3,7,5,5,7,3,1,3,5,1,7,7,1,5,3];

describe("Game", function () {

  it("Should deploy the contract and get a state back", async function () {
    const Game = await ethers.getContractFactory("Game");
    const game = await Game.deploy();
    await game.deployed();

    let state = await game.getState(); 
    expect(state.length > 0 ).to.equal(true); 

  });

  it("Should validate a board and update initial state", async function () {
    const Game = await ethers.getContractFactory("Game");
    const game = await Game.deploy();
    await game.deployed();

    let initialState = await game.getState(); 
    console.log(initialState);
    let txn = await game.verifySolution(validBoard); 
    await txn.wait(); 

    let newState = await game.getState(); 
    newState = await game.getState(); 
    console.log(newState)
    expect(initialState).not.equal(newState)
  }); 

  it("Should iterate total games when a new game is saved.", async function () {
    const Game = await ethers.getContractFactory("Game");
    const game = await Game.deploy();
    await game.deployed();

    for(let i=0; i < 10; i++) {
        txn = await game.verifySolution(validBoard); 
        await txn.wait(); 
    }
    let count = await game.getGames(); 
    expect(count).equal(10);
  });

});
