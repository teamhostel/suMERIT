import { useEffect } from 'react';
import { useState } from 'react';
import { ethers } from "ethers";
import './App.css';
import contract from './contracts/BadgeFactory.json';
import PageHeader from './PageHeader';
import BadgeCreationForm from './BadgeCreationForm';
import MeritSubmitForm from './MeritSubmitForm';
import { ContractFactory } from 'ethers';

const badgeFactoryOwner = "";
const abi = contract.abi;

function App() {

  const [currentAccount, setCurrentAccount, balance] = useState(null);

  const checkWalletIsConnected = async () => {
    const { ethereum } = window;

    if (!ethereum){
      console.log("Make sure you have Metamask installed");
      return;
    }else{
      console.log("Wallet exists!")
    }

    const accounts = await ethereum.request({ method: 'eth_accounts' });

    if (accounts.length !== 0) {
      const account = accounts[0];
      console.log("Found an authorized account: ", account);
      setCurrentAccount(account);
    }else{
      console.log("Not Authorized");
    }
  }

  const connectWalletHandler = async () => {
    const { ethereum } = window;

    if (!ethereum){
      alert("Please install Metamask");
    }

    try{
      const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
      console.log("Found an account: ", accounts[0]);
      setCurrentAccount(accounts[0]);
    }catch (err){
      alert(err.message)
    }

  }

  const mintBadge = async() => {
    try{
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const nftContract = new ethers.Contract(badgeFactoryOwner, abi, signer);

        console.log("Initialize Payment");
        const memberAddress = "0x2c2D987Df8ffbe670C32cC80a56DdB76c0CffED7";
        let nftTxn = await nftContract.addDaoMember(memberAddress);

        console.log("Minting...");
        await nftTxn.wait();

        console.log(`Minted, see transaction: https://stardust-explorer.metis.io/tx/${nftTxn.hash}/internal-transactions`);
      } else {
        console.log("Ethereum object does not exist");
      }
    } catch (err) {
      alert(err.message);
    }

  }

  const connectWalletButton = () => {
    return (
      <button onClick={connectWalletHandler} className='cta-button connect-wallet-button'>
        Connect Wallet
      </button>
    )
  }

const deployBadgeFactory = async () => {

  try{
    const { ethereum } = window;

  const provider = new ethers.providers.Web3Provider(ethereum);
  const signer = provider.getSigner();

      const factory = new ContractFactory(abi, contract.bytecode, signer);

      // If your contract requires constructor args, you can specify them here
      const factoryContract = await factory.deploy('suMERIT', 'SUM', 'https://bafybeidxwh2zr5yvmlel6vqlqv3lkjpselleyobjdejg7v55cyeipinb5a.ipfs.dweb.link/');

      console.log(factoryContract.address);
      console.log(factoryContract.deployTransaction);

  }catch (err) {
    alert(err.message);
  }
}

  const deployFactoryButton = () => {
    return (
      <button onClick={deployBadgeFactory} className='cta-button connect-wallet-button'>
        Deploy DAO Factory Contract
      </button>
    )
  }

  const mintBadgeButton = () => {
    return (
      <button onClick={mintBadge} className='cta-button mint-nft-button'>
        Mint NFT
      </button>
    )
  }

  const getBalance = async() => {
    const { ethereum } = window;
    const provider = new ethers.providers.Web3Provider(ethereum);
    const balance = await provider.getBalance("ethers.eth");
    return balance
  }

  return (

    <div className="App">
    <PageHeader />



      <div className='container'>
        <div className="grid grid-cols gap-4">
          <div className="bg-white shadow-lg p-4 shadow-xl rounded">
          <h2 className="uppercase font-black">Create Badge Factory</h2>
          {deployFactoryButton()}
          </div>
          <div className="bg-white shadow-lg p-4 shadow-xl rounded">
            <h2 className="uppercase font-black">DAO Way</h2>
            <p className="text-sm text-left">This is the way of the DAO. A DAO should follow this path in order to mint their Badge Factory. Once a Badge Factory is created and the design of the DAO's badge is finalized all members will be able to mint their individual badges.</p>

            {mintBadgeButton()}

          </div>
          <div className="bg-white shadow-lg p-4 rounded">
            <h2 className="uppercase font-black">Contrib Way</h2>
            <p className="text-sm text-left">This is the way of the contributor. A contributor can mint a base badge for every DAO that they are a member of. Their contributions to the DAO can then be recognized as they earn their stripes. Each stripe is a minted SVG that includes the metadata of the attested contribution.
            </p>
          </div>
          <MeritSubmitForm />
        </div>
      </div>

    </div>

  );

}

export default App;
