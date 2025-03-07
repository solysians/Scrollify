# NFT Marketplace Interaction

This project provides a JavaScript implementation for interacting with an NFT Factory and Marketplace smart contracts using `ethers.js`.

## Prerequisites

Before using this script, ensure you have:
- Node.js installed
- Metamask or any Web3-enabled wallet
- A deployed NFT Factory and Marketplace smart contract
- The corresponding contract ABI files placed in the root directory

## Installation

To use the script, install the required dependencies:
```sh
npm install ethers
```

## Contract Setup

The script interacts with the following smart contracts:
- **Factory Contract**: Deploys NFT collections
- **Royalty Contract**: Handles NFT minting
- **Marketplace Contract**: Manages NFT listings, sales, and cancellations

Make sure to replace `factoryAddress` and `marketPlaceAddress` with actual contract addresses.

## Functions

### 1. `createCollection(name, symbol, maxSupply)`
Creates a new NFT collection.
#### Usage:
```js
await createCollection("MyNFT", "MNFT", 1000);
```
#### Flow:
1. Calls `createCollection` on the Factory Contract
2. Waits for the transaction to be mined
3. Retrieves and logs the event data

### 2. `mint(tokenURI, royaltyBasisPoints)`
Mints an NFT with royalty details.
#### Usage:
```js
await mint("ipfs://metadataURI", 500);
```
#### Flow:
1. Calls `safeMint` on the Royalty Contract
2. Waits for transaction confirmation
3. Logs success message

### 3. `list(nftContract, tokenId, price)`
Lists an NFT on the marketplace.
#### Usage:
```js
await list("0xNFTContractAddress", 1, "0.1");
```
#### Flow:
1. Calls `listNFT` on the Marketplace Contract
2. Waits for confirmation
3. Retrieves and logs `NFTListed` event

### 4. `buy(tokenId, price)`
Buys an NFT from the marketplace.
#### Usage:
```js
await buy(1, "0.1");
```
#### Flow:
1. Calls `buyNFT` on the Marketplace Contract
2. Sends ETH equivalent to `price`
3. Retrieves and logs `NFTSold` event

### 5. `cancelListing(listingId)`
Cancels an active NFT listing.
#### Usage:
```js
await cancelListing(1);
```
#### Flow:
1. Calls `cancelListing` on the Marketplace Contract
2. Waits for confirmation
3. Retrieves and logs `ListingCanceled` event

## Event Handling
The function `getEvent(receipt, eventName)` retrieves event details from a transaction receipt.

## Known Issues & Fixes
- `window.etherum` should be `window.ethereum`
- `Symbol` should be `symbol` in `createCollection`
- `ethers.utils.parsEther(price)` should be `ethers.utils.parseEther(price)`
- `receipt.events.find((e) => e.events === eventName)` should be `receipt.events.find((e) => e.event === eventName)`
- Ensure `contractSigner` is properly assigned if using multiple signers

## Contributing
If you find any issues or want to improve this project, feel free to submit a pull request.