# suMERIT
[Notion Page](https://futuretrees.notion.site/suMERIT-TEAM-HOSTEL-Eth-Denver-f39352440945410392c08d544f289a6f)

First place: METIS Bounty @ Eth Denver 2022
- [Announcement](https://twitter.com/MetisDAO/status/1499791463126904839)
- [See all Eth Denver Winners](https://www.ethdenver.com/2022-irl-winners)

### Modular DAO Badge NFT  | on-chain Contribution & Attestation recorder

- DAO deploys a Badge Factory Contract, allowing DAO to batch mint NFT badges for all DAO members

  - These badges are on-chain journals for you to document your contribs to your DAO. 
  - Plus, badge carrying members gain the right to write attestations to your badge, including a yes/no vote and a string message. 
  - All data is stored in the Badge NFT as a mapping.
  - Render your contribs and attests as an SVG badge
- This concept is primarily **non-financial**, thus works best on cheap chains or rollups, but the data from badges...

  - Could set up inter-dao undercollateralized lending markets!
  - Could weight voting power based on time in DAO and contribution history!
  - Could be a portable self-sovereign resume, which allows partner DAOs to "Level Boost" a new member based on their contrib & attest history in other DAOs!

Please **fork** and **contrib** if you like our concept. Thanks for your time, looking forward to collaborating!

## setup & test
  ```
  yarn
  yarn hardhat compile
  yarn hardhat test
  ```
## BadgeFactory is Badge
This contract is owned by the DAO wallet. In future, will be deployed by Badge Factory Manager contract - which will customize your DAO's Badge Factory.
### modifiers
- `onlyMember`: must own one Badge NFT
- `onlyHolder`: must own this Badge ID
### storage

### functions

## Todo: 
- simplify mappings (less dimensions)
- Complete the test cases
- Rebuild front end
- Create "Badge Factory Manager" inspired from Zora Module Manager- it's job is to deploy configured badge factories.
- Render the badges as SVGs from all the internal content. The entire badge can be made from contribution/attestation text. Think word art!


---

# Hardhat boilerplate project docs
This project demonstrates an advanced Hardhat use case, integrating other tools commonly used alongside Hardhat in the ecosystem.

The project comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts. It also comes with a variety of other tools, preconfigured to work with the project code.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.ts
TS_NODE_FILES=true npx ts-node scripts/deploy.ts
npx eslint '**/*.{js,ts}'
npx eslint '**/*.{js,ts}' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```

# Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Ropsten.

In this project, copy the .env.example file to a file named .env, and then edit it to fill in the details. Enter your Etherscan API key, your Ropsten node URL (eg from Alchemy), and the private key of the account which will send the deployment transaction. With a valid .env file in place, first deploy your contract:

```shell
hardhat run --network ropsten scripts/sample-script.ts
```

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```

# Performance optimizations

For faster runs of your tests and scripts, consider skipping ts-node's type checking by setting the environment variable `TS_NODE_TRANSPILE_ONLY` to `1` in hardhat's environment. For more details see [the documentation](https://hardhat.org/guides/typescript.html#performance-optimizations).
