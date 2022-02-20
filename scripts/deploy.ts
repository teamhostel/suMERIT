// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { Signer } from "ethers";
import { BadgeFactory } from "../typechain";
async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const BadgeFactory = await ethers.getContractFactory("BadgeFactory");
  const myName = "Future Trees";
  const mySymbol = "FT";
  const bf = await BadgeFactory.deploy(myName, mySymbol);

  await bf.deployed();

  console.log("Badge Factory 0 Deployed to: ", bf.address);
  console.log(myName);
  console.log(mySymbol);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
