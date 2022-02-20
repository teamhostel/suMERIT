import { expect } from "chai";
import { ethers } from "hardhat";
import { BadgeFactory } from "../typechain";

describe("DAO creates BadgeFactory", function () {
  it("Mints the badge for two members. Then batch adds three members", async function singleMint() {
    //deployer of contract type BadgeFactory
    const BadgeFactory = await ethers.getContractFactory("BadgeFactory");
    const myName = "Test Badge";
    const mySymbol = "TB"
    const bf = await BadgeFactory.deploy(myName, mySymbol);
    await bf.deployed();
    expect(await bf.name()).to.equal(myName);
    expect(await bf.symbol()).to.equal(mySymbol);

    const [owner, futuretrees, myco, ryan, karma, leo] = await ethers.getSigners();
    const myDaoNewbies = [ryan.address, karma.address, leo.address];

    await bf.connect(owner).addDaoMember(futuretrees.address);
    await bf.connect(owner).addDaoMember(myco.address);

    await bf.connect(owner).batchAddMembers(myDaoNewbies);

    await bf.connect(futuretrees).addNewStripe("Peyton did the smart contracts at ethDenver", "ipfs::");
    await bf.connect(myco).addNewStripe("Myco did a lotta drawing", "ipfs::");

    expect(await bf.connect(owner).getAddressById(0)).to.equal(futuretrees.address);
    expect(await bf.getAddressById(1)).to.equal(myco.address);
    expect(await bf.getAddressById(2)).to.equal(ryan.address);
    expect(await bf.getAddressById(3)).to.equal(karma.address);
    expect(await bf.getAddressById(4)).to.equal(leo.address);
    
  });

  it("Batch adds members by minting badges to an array of addresses", async function batchMint() {
    
  })

  it("Adds stripes to existing badges", async function () {

  });
});
