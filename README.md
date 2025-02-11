# Scrollify
Scroll, fun and do some real stuff

## ERC721

MyToken is an ERC721-compliant NFT smart contract built using OpenZeppelin's Solidity library. It supports minting, burning, and URI storage for metadata. The contract follows best practices for ownership and access control.

### Features

- ERC721 standard for NFTs

- Burnable tokens (owners can destroy their tokens)

- Metadata storage using URI

- Ownership control (only the contract owner can mint new tokens)

### Dependencies

This contract uses OpenZeppelin's ERC721 implementation:

- `@openzeppelin/contracts@5.2.0/token/ERC721/ERC721.sol`

- `@openzeppelin/contracts@5.2.0/token/ERC721/extensions/ERC721Burnable.sol`

- `@openzeppelin/contracts@5.2.0/token/ERC721/extensions/ERC721URIStorage.sol`

- `@openzeppelin/contracts@5.2.0/access/Ownable.sol`

### Deployment

1. Ensure you have Solidity version 0.8.24 installed.

2. Use a development environment like Hardhat or Foundry.

3. Deploy the contract by passing the initial owner's address to the constructor.

### Functions

`safeMint(address to, string memory uri)`

- Mints a new NFT to the specified address.

- Only callable by the contract owner.

- Stores a metadata URI for the NFT.

`tokenURI(uint256 tokenId) -> string`

- Returns the metadata URI associated with a given token ID.

`burn(uint256 tokenId)`

- Allows the owner of an NFT to burn (destroy) it.

`supportsInterface(bytes4 interfaceId) -> bool`

- Returns true if the contract supports a specific interface (ERC721, ERC721Metadata, etc.).


##ERC115

MyToken is an ERC1155-compliant multi-token smart contract built using OpenZeppelin's Solidity library. It supports batch minting, burning, and supply tracking while implementing role-based access control.

### Features

- ERC1155 standard for multi-token support

- Burnable tokens (owners can destroy their tokens)

- Batch minting for efficiency

- Role-based access control for minting and URI setting

- Supply tracking for each token type

### Dependencies

This contract uses OpenZeppelin's ERC1155 implementation:

- `@openzeppelin/contracts@5.2.0/access/AccessControl.sol`

- `@openzeppelin/contracts@5.2.0/token/ERC1155/ERC1155.sol`

- `@openzeppelin/contracts@5.2.0/token/ERC1155/extensions/ERC1155Burnable.sol`

- `@openzeppelin/contracts@5.2.0/token/ERC1155/extensions/ERC1155Supply.sol`

### Deployment

- Ensure you have Solidity version 0.8.24 installed.

- Use a development environment like Hardhat or Foundry.

- Deploy the contract by passing the default admin and minter addresses to the constructor.

### Functions

`setURI(string memory newuri)`

- Updates the base URI for metadata.

- Only callable by an account with the URI_SETTER_ROLE.

`mint(address account, uint256 id, uint256 amount, bytes memory data)`

- Mints new tokens of a given ID and amount to the specified address.

- Only callable by an account with the MINTER_ROLE.

`mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)`

- Mints multiple token types in a single transaction.

- Only callable by an account with the MINTER_ROLE.

`burn(address account, uint256 id, uint256 amount)`

- Allows the owner of tokens to burn a specified amount of a given token ID.

`supportsInterface(bytes4 interfaceId) -> bool`

- Returns true if the contract supports a specific interface (ERC1155, AccessControl, etc.).
