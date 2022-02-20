const { expect } = require("chai");
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { Signer } from "ethers";
import { ethers } from "hardhat";
import { it } from "mocha";
import { BadgeFactory } from "../typechain";
import { Stripe } from "../typechain/Stripe";
describe("suMERIT Contracts", function () {
  // Mocha has four functions that let you hook into the the test runner's
  // lifecyle. These are: `before`, `beforeEach`, `after`, `afterEach`.

  // They're very useful to setup the environment for tests, and to clean it
  // up after they run.

  // A common pattern is to declare some variables, and assign them in the
  // `before` and `beforeEach` callbacks.

  let BadgeFactory;
  //must explicitly define type in this rare instance!
  let bf: BadgeFactory;

  let owner: SignerWithAddress;
  let futuretrees: SignerWithAddress;
  let myco: SignerWithAddress;
  let ryan: SignerWithAddress;
  let karma: SignerWithAddress;
  let leo: SignerWithAddress;

  before(async function () {
    BadgeFactory = await ethers.getContractFactory("BadgeFactory");
    [owner, futuretrees, myco, ryan, karma, leo] = await ethers.getSigners();
    const myName = "Test Badge";
    const mySymbol = "TB"
    bf = await BadgeFactory.deploy(myName, mySymbol);
    await bf.deployed();
    expect(await bf.name()).to.equal(myName);
    expect(await bf.symbol()).to.equal(mySymbol);
    console.log("\tBadgeFactory successfully deployed");
  });

  // `beforeEach` will run before each test, re-deploying the contract every
  // time. It receives a callback, which can be async.
  beforeEach(async function () {

  });

  describe("DAO adds members by minting badges!", function () {
    it("Should mint the badge manually for two members. Then batch adds three members", async function singleMint() {
      //deployer of contract type BadgeFactory
      await bf.connect(owner).addDaoMember(futuretrees.address);
      await bf.connect(owner).addDaoMember(myco.address);

      expect(await bf.connect(owner).getAddressById(0)).to.equal(futuretrees.address);
      expect(await bf.getAddressById(1)).to.equal(myco.address);

    });

    it("Should batch add 3 members by minting badges to an array of member addresses", async function batchMint() {
      const myDaoNewbies = [ryan.address, karma.address, leo.address];
      await bf.connect(owner).batchAddMembers(myDaoNewbies);

      expect(await bf.getAddressById(2)).to.equal(ryan.address);
      expect(await bf.getAddressById(3)).to.equal(karma.address);
      expect(await bf.getAddressById(4)).to.equal(leo.address);
    });
  });

  describe("DAO members can create stripes on their badge, to define contribution goals!", function () {
    it("Should append new stripes to existing badges", async function createStripes() {
      const peyTrib = "Peyton did the smart contracts at ethDenver";
      const mycoTrib = "Myco did a lotta drawing";
      await bf.connect(futuretrees).addNewStripe(peyTrib, "ipfs::");
      await bf.connect(myco).addNewStripe(mycoTrib, "ipfs::");

      expect(await bf.getStripeMessageById(0, 0)).to.equal(peyTrib);
      expect(await bf.getStripeUriById(0, 0)).to.equal("ipfs::");
      expect((await bf.stripesById(0, 0)).contribSize).to.equal(0);
      expect((await bf.stripesById(0, 0)).attestSize).to.equal(0);
      expect(await bf.getStripeMessageById(1, 0)).to.equal(mycoTrib);
      expect((await bf.stripesById(1, 0)).contribSize).to.equal(0);
    });

    it("Should add contributions and view them", async function appendContribs() {
      const contribMsg = "I am writing test cases for our hack";
      //test contrib to specific stripe
      bf.connect(futuretrees).contribToStripe(0, "I am writing test cases for our hack", "solidity", "ipfs::");

      const myMessage = await bf.connect(owner).getContribMessage(0, 0, 0); //had to specify explicitly connecting with wallet address
      const contribType = await bf.connect(owner).getContribType(0, 0, 0); //had to specify explicitly connecting with wallet address
      const ipfs = await bf.connect(futuretrees).getContribUri(0, 0, 0);
      const time = await bf.connect(futuretrees).getContribTime(0,0,0);
      expect(myMessage).to.equal(contribMsg);
      expect(contribType).to.equal("solidity");
      console.log("\tMy message:  ", myMessage);
      console.log("\tcontrib Type: ", contribType);
      console.log("\tipfs link: ", ipfs);
      console.log("\ttime: ", time);
    });

    it("Should add Contribs to the latest Stripe", async function appendContri() {
      bf.connect(myco).contribToLatestStripe(0, "I am writing test cases for our hack", "solidity", "ipfs::");
    })

    it("Should allow DAO members to vote on stripes", async function appendAttest() {
      const myVote = false;
            
    });
  });

});
