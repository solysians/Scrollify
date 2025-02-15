# MyToken - ERC721 NFT Contract

## 📌 Overview
**MyToken (MTK)** is an ERC721-based NFT smart contract built on the Ethereum blockchain. This contract allows users to mint, transfer, and burn unique NFTs, with metadata stored off-chain.

## ⚡ Features
- 🛠 **Minting**: Users can mint unique NFTs.
- 🔥 **Burning**: Token owners can burn their NFTs.
- 📦 **Metadata Storage**: Uses tokenURI to manage metadata.
- ✅ **Interoperability**: Follows the ERC721 standard for compatibility with marketplaces.

## 📜 Smart Contract
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    constructor(address initialOwner)
        ERC721("MyToken", "MTK")
        Ownable(initialOwner)
    {}

    function safeMint(address to, uint256 tokenId, string memory uri) public {
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory){
        return super.tokenURI(tokenId);
    }
}
```

## 🚀 How to Use

### 1️⃣ **Clone the Repository**
```bash
git clone https://github.com/yourusername/your-repo.git
cd your-repo
```

### 2️⃣ **Install Dependencies**
```bash
npm install
yarn install # (if using yarn)
```

### 3️⃣ **Compile the Contract**
```bash
npx hardhat compile
```

### 4️⃣ **Deploy the Contract**
```bash
npx hardhat run scripts/deploy.js --network goerli
```

### 5️⃣ **Mint an NFT**
```javascript
const tx = await contract.safeMint("0xYourAddress", 1, "ipfs://your-metadata-uri");
await tx.wait();
console.log("NFT Minted!");
```

## 🏗 Tech Stack
- **Solidity** (Smart Contracts)
- **Hardhat** (Development & Testing)
- **OpenZeppelin** (ERC721 Standard Library)
- **IPFS** (Metadata Storage)

## 🛡 Security Considerations
- Uses **OpenZeppelin's ERC721** implementation for security and standardization.
- Ownership restricted to **prevent unauthorized minting**.

## 📜 License
This project is licensed under the **MIT License**.

## 📞 Contact
For any issues or contributions, reach out via GitHub Issues or sidharth.120504@gmail.com