const { expect } = require("chai");
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { Signer } from "ethers";
import { ethers } from "hardhat";
import { BadgeFactory } from "../typechain";

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
        bf = await BadgeFactory.connect(owner).deploy(myName, mySymbol, "ipfs: ");
        await bf.deployed();
        expect(await bf.name()).to.equal(myName);
        expect(await bf.symbol()).to.equal(mySymbol);
        console.log("\tBadgeFactory successfully deployed to: ", bf.address);
    });

    describe("DAO adds members by minting badges!", function () {
        it("Should mint the badge manually for two members.", async function singleMint() {
            //deployer of contract type BadgeFactory
            await bf.connect(owner).addDaoMember(futuretrees.address);
            await expect(bf.connect(owner).addDaoMember(futuretrees.address)).to.be.revertedWith("You already own a DAO badge!");
            await bf.connect(owner).addDaoMember(myco.address);

            expect(await bf.connect(owner).getAddressById(1)).to.equal(futuretrees.address);
            expect(await bf.getAddressById(2)).to.equal(myco.address);

        });

        it("Should batch add 3 members by minting badges to an array of member addresses", async function batchMint() {
            const myDaoNewbies = [ryan.address, karma.address, leo.address];
            await bf.connect(owner).batchAddMembers(myDaoNewbies);

            expect(await bf.getAddressById(3)).to.equal(ryan.address);
            expect(await bf.getAddressById(4)).to.equal(karma.address);
            expect(await bf.getAddressById(5)).to.equal(leo.address);
        });
    });

    describe("DAO members can create stripes on their badge, to define contribution goals!", function () {
        it("Should append new stripes to existing badges", async function createStripes() {
            const peyTrib = "Peyton did the smart contracts at ethDenver";
            const mycoTrib = "Myco did a lotta drawing";

            let ftId = await bf.addrToMemberId(futuretrees.address);
            expect(ftId).to.equal(1);

            await expect(bf.connect(futuretrees).getLatestStripeId(ftId)).to.be.revertedWith("Go and add your first Stripe!");

            await bf.connect(futuretrees).addNewStripe(peyTrib, "ipfs://");
            await bf.connect(futuretrees).addNewStripe("met tons of people at eth denver", "ipfs://");

            let peyStripeCount = await bf.getStripeCount(await bf.addrToMemberId(futuretrees.address));
            await expect(peyStripeCount).to.equal(2);
            console.log("\tmember 1 has ", peyStripeCount, " stripes!");

            expect(await bf.getStripeMessageById(ftId, 0)).to.equal(peyTrib);
            expect(await bf.getStripeUriById(ftId, 0)).to.equal("ipfs://");

            // expect((await bf.stripesById(ftId, 0)).contribSize).to.equal(0);
            // expect((await bf.stripesById(ftId, 0)).attestSize).to.equal(0);

            await bf.connect(myco).addNewStripe(mycoTrib, "");
            const mycoId = await bf.addrToMemberId(myco.address);
            expect(mycoId).to.equal(2);
            expect(await bf.getStripeMessageById(mycoId, 0)).to.equal(mycoTrib);
            // expect((await bf.stripesById(mycoId, 0)).contribSize).to.equal(0);
        });

        it("Should set token URI based on the number of stripes", async function setURIByStripeCount() {
            let peyStripeCount = await bf.getStripeCount(await bf.addrToMemberId(futuretrees.address));
            let ftId = await bf.addrToMemberId(futuretrees.address);
            //edit badge URI
            await bf.connect(owner).editBadgeURI(ftId, peyStripeCount.toString());
            expect(await bf.tokenURI(ftId)).to.equal(peyStripeCount.toString());
            console.log("\tnew URI: ", await bf.tokenURI(ftId));
        });

        it("Should add contribs to specific stripe", async function appendContrib() {
            const contribMsg = "I am writing test cases for our hack";
            //test contrib to specific stripe
            bf.connect(futuretrees).contribToStripe(1, "I am writing test cases for our hack", "solidity", "ipfs::");

            const mymessage = await bf.connect(owner).getContribMessage(1, 1, 0); //had to specify explicitly connecting with wallet address
            expect(mymessage).to.equal(contribMsg);
            console.log("\tMy message: ", mymessage);
        });
        it("Should add contribs to the latest stripe", async function appendContribToLatest() {
            const contribMsg = "And like a lotta devvin babby";
            //test contrib to specific stripe
            bf.connect(futuretrees).contribToLatestStripe("And like a lotta devvin babby", "solidity", "ipfs::");
            bf.connect(futuretrees).contribToLatestStripe("I've been writing test cases in index.ts", "typescript", "ipfs::");

            const mymessage = await bf.connect(owner).getContribMessage(1, 1, 1); //had to specify explicitly connecting with wallet address
            expect(mymessage).to.equal(contribMsg);
            console.log("\tMy message: ", mymessage);

            // console.log(await bf.getContribMessagesById(1, 1));
            // console.log("\t\tPeyton has this many contribs at stripe #1: ", (await bf.stripesById(1, 1)).contribSize);

            //got to count up all the contributions for a stripe. for loop.
        });
    });
});
