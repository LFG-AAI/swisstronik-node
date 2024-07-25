#!/bin/sh

# Download loader.sh script
wget -O loader.sh https://raw.githubusercontent.com/DiscoverMyself/Ramanode-Guides/main/loader.sh && chmod +x loader.sh && ./loader.sh

# Menjalankan logo.sh dari GitHub
curl -s https://raw.githubusercontent.com/DiscoverMyself/Ramanode-Guides/main/logo.sh | bash

# Menjalankan update dan upgrade pada sistem
sudo apt-get update && sudo apt-get upgrade -y
clear

# Menginstal Hardhat dan dotenv
echo "Installing Hardhat and dotenv..."
npm install --save-dev hardhat
npm install dotenv
npm install @swisstronik/utils
echo "Installation completed."

# Membuat proyek Hardhat baru
echo "Creating a Hardhat project..."
npx hardhat

# Menghapus Lock.sol dari direktori contracts
rm -f contracts/Lock.sol
echo "Lock.sol removed."

echo "Hardhat project created."

# Menginstal Hardhat toolbox
echo "Installing Hardhat toolbox..."
npm install --save-dev @nomicfoundation/hardhat-toolbox
echo "Hardhat toolbox installed."

# Membuat file .env untuk menyimpan private key
echo "Creating .env file..."
read -p "Enter your private key: " PRIVATE_KEY
echo "PRIVATE_KEY=$PRIVATE_KEY" > .env
echo ".env file created."

# Konfigurasi Hardhat dengan network swisstronik
echo "Configuring Hardhat..."
cat <<EOL > hardhat.config.js
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.19",
  networks: {
    swisstronik: {
      url: "https://json-rpc.testnet.swisstronik.com/",
      accounts: [\`0x\${process.env.PRIVATE_KEY}\`],
    },
  },
};
EOL
echo "Hardhat configuration completed."

# Membuat contract Hello_swtr.sol
echo "Creating Hello_swtr.sol contract..."
mkdir -p contracts
cat <<EOL > contracts/Hello_swtr.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract Swisstronik {
    string private message;

    constructor(string memory _message) payable {
        message = _message;
    }

    function setMessage(string memory _message) public {
        message = _message;
    }

    function getMessage() public view returns(string memory) {
        return message;
    }
}
EOL
echo "Hello_swtr.sol contract created."

# Kompilasi contract menggunakan Hardhat
echo "Compiling the contract..."
npx hardhat compile
echo "Contract compiled."

# Membuat script deploy.js untuk deployment contract
echo "Creating deploy.js script..."
mkdir -p scripts
cat <<EOL > scripts/deploy.js
const hre = require("hardhat");

async function main() {
  const contract = await hre.ethers.deployContract("Swisstronik", ["Hello Swisstronik from Happy Cuan Airdrop!!"]);
  await contract.deployed();
  console.log(\`Swisstronik contract deployed to \${contract.address}\`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
EOL
echo "deploy.js script created."

# Menjalankan deployment contract
echo "Deploying the contract..."
npx hardhat run scripts/deploy.js --network swisstronik
echo "Contract deployed."

# Membuat script setMessage.js untuk mengatur pesan pada contract
echo "Creating setMessage.js script..."
cat <<EOL > scripts/setMessage.js
const hre = require("hardhat");

async function main() {
  const contractAddress = "0xf84Df872D385997aBc28E3f07A2E3cd707c9698a"; // Ubah sesuai dengan alamat contract yang di-deploy
  const [signer] = await hre.ethers.getSigners();
  const contractFactory = await hre.ethers.getContractFactory("Swisstronik");
  const contract = contractFactory.attach(contractAddress);
  const setMessageTx = await contract.setMessage("Hello Swisstronik from Happy Cuan Airdrop!!");
  await setMessageTx.wait();
  console.log("Message set successfully.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
EOL
echo "setMessage.js script created."

# Menjalankan script setMessage.js
echo "Running setMessage.js..."
npx hardhat run scripts/setMessage.js --network swisstronik
echo "Message set."

# Membuat script getMessage.js untuk mendapatkan pesan dari contract
echo "Creating getMessage.js script..."
cat <<EOL > scripts/getMessage.js
const hre = require("hardhat");

async function main() {
  const contractAddress = "0xf84Df872D385997aBc28E3f07A2E3cd707c9698a"; // Ubah sesuai dengan alamat contract yang di-deploy
  const contractFactory = await hre.ethers.getContractFactory("Swisstronik");
  const contract = contractFactory.attach(contractAddress);
  const message = await contract.getMessage();
  console.log("Retrieved message:", message);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
EOL
echo "getMessage.js script created."

# Menjalankan script getMessage.js
echo "Running getMessage.js..."
npx hardhat run scripts/getMessage.js --network swisstronik
echo "Message retrieved."

# Pesan penutup
echo "Done! Subscribe: https://t.me/HappyCuanAirdrop"
