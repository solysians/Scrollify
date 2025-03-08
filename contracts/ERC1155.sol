// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract MyERC1155 is ERC1155, Ownable {
    uint256 public maxSupply;
    uint256 public tokenIdCounter;

    constructor(string memory uri, uint256 _maxSupply) ERC1155(uri) Ownable(msg.sender) {
        maxSupply = _maxSupply;
    }

    function mintToken(uint256 amount, string memory uri) external onlyOwner {
        require(tokenIdCounter < maxSupply, "Max supply reached!");
        tokenIdCounter++;
        _mint(msg.sender, tokenIdCounter, amount, "");
        _setURI(uri);
    }

    function mintMore(uint256 tokenId, uint256 amount) external onlyOwner {
        require(tokenId <= tokenIdCounter, "Token does not exist!");
        _mint(msg.sender, tokenId, amount, "");
    }
}

contract NFTFactory is Ownable {
    event CollectionCreated(address collectionAddress, address owner);

    constructor() Ownable(msg.sender) {}

    function createCollection(string memory name, string memory symbol, uint256 maxSupply) external {
        MyERC1155 newCollection = new MyERC1155(symbol, maxSupply);
        newCollection.transferOwnership(msg.sender);
        emit CollectionCreated(address(newCollection), msg.sender);
    }
}