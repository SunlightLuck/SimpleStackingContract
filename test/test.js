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

    await stackingContract.stackTokens(tokenContract, 10);

    expect(await stackingContract.timeStampSet()).to.be.equal(true);
  });
});
