import { useEffect } from 'react';
import { useState } from 'react';
import logo from './logo.svg';
import './App.css';
import contract from './contracts/BadgeFactory.json';

const contractAddress = "0x";
const abi = contract.abi;

function App() {
  const [currentAccount, setCurrentAccount] = useState(null);

  const checkWalletIsConnected = () => {
    const { ethereum } = window;

    if (!ethereum){
      console.log("Make sure you have Metamask installed");
      return;
    }else{
      console.log("Wallet exists!")
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
      console.log(err)
    }

  }

  const mintNftHandler = () => { }

  const connectWalletButton = () => {
    return (
      <button onClick={connectWalletHandler} className='cta-button connect-wallet-button'>
        Connect Wallet
      </button>
    )
  }

  const mintNftButton = () => {
    return (
      <button onClick={mintNftHandler} className='cta-button mint-nft-button'>
        Mint NFT
      </button>
    )
  }
  return (
    <div className="App">
      <header className="App-header">
        <h1>MERIT - Contribute to the power of the DAO</h1>


    <div className='main-app'>
      <h1></h1>
      <div>
        {connectWalletButton()}
      </div>
    </div>

      </header>
    </div>
  );
}

export default App;
