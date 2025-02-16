// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Royalty} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Royalty is ERC721,ERC721Royalty, ERC721URIStorage, ERC721Burnable, Ownable {
    uint256 public maxSupply = 0;
    uint256 tokenId = 0;
    event Received(address sender, uint256 amount);

    constructor(string memory name,string memory symbol,uint256 _maxSupply) ERC721(name, symbol) Ownable(msg.sender){
        maxSupply = _maxSupply;
    }

    function safeMint(string memory uri) public {
        require(tokenId < maxSupply,"Max supply reached!");
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);
        _setTokenRoyalty(tokenId, msg.sender,500);
        tokenId++;
    }

    receive() external payable {
        emit Received(msg.sender, msg.value); // Emit an event for logging
    }

    // The following functions are overrides required by Solidity.
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721,ERC721Royalty, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory){
        return super.tokenURI(tokenId);
    }
}

contract NFTFactory {
    event CollectionCreated(address collectionAddress, address owner);

    function createCollection(string memory name, string memory symbol,uint256 maxSupply) public {
        Royalty newCollection = new Royalty(name, symbol,maxSupply);
        emit CollectionCreated(address(newCollection), msg.sender);
    }
}