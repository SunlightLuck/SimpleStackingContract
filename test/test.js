const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const stackingContractFactory = await ethers.getContractFactory("SimpleStackingContract");
    const tokenContractFactory = await ethers.getContractFactory("SimpleToken");
    const tokenContract = await tokenContractFactory.deploy();
    const stackingContract = await stackingContractFactory.deploy(tokenContract);
    await tokenContract.deployed();
    await stackingContract.deployed();

    expect(await greeter.greet()).to.equal("Hello, world!");

    const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

    // wait until the transaction is mined
    await setGreetingTx.wait();

    expect(await greeter.greet()).to.equal("Hola, mundo!");
  });
});
