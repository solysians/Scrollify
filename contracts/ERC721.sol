// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC721Royalty} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Royalty is ERC721,ERC721Royalty, ERC721URIStorage, ERC721Burnable, Ownable {
    uint256 public maxSupply = 0;
    uint256 tokenId = 0;
    event Received(address sender, uint256 amount);

    constructor(string memory name,string memory symbol,uint256 _maxSupply) 
    ERC721(name, symbol) 
    Ownable(msg.sender){
        maxSupply = _maxSupply;
    }

    function safeMint(string memory uri,uint96 royaltyBasisPoints) public onlyOwner {
        require(tokenId < maxSupply,"Max supply reached!");
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);
        _setTokenRoyalty(tokenId, msg.sender,royaltyBasisPoints);
        tokenId++;
    }

    receive() external payable {
        emit Received(msg.sender, msg.value); 
    }

    // The following functions are overrides required by Solidity.
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721,ERC721Royalty, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory){
        return super.tokenURI(tokenId);
    }
}

contract NFTFactory is Ownable{
    event CollectionCreated(address collectionAddress, address owner);
    constructor() Ownable(msg.sender){}

    function createCollection(string memory name, string memory symbol,uint256 maxSupply) public {
        Royalty newCollection = new Royalty(name, symbol,maxSupply);
        newCollection.transferOwnership(msg.sender);
        emit CollectionCreated(address(newCollection), msg.sender);
    }
}

contract MarketPlace is ReentrancyGuard{
    struct Listing {
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bool isActive;
    }

    mapping(uint256 => Listing) public listings;

    uint256 public listingIdCounter;

    //Events
    event NFTListed(uint256 indexed listingId, address indexed seller, address indexed nftContract, uint256 tokenId, uint256 price);
    event NFTSold(uint256 indexed listingId, address indexed buyer, address indexed nftContract, uint256 tokenId, uint256 price);
    event ListingCanceled(uint256 indexed listingId);

    //Functions

    function listNFT(address nftContract,uint256 tokenId,uint256 price) public nonReentrant {
        require(price > 0,"you can sell NFTs for free!!");
        listingIdCounter++;
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        listings[listingIdCounter] = Listing({
            seller : msg.sender,
            nftContract : nftContract,
            tokenId : tokenId,
            price : price,
            isActive : true
        });

        emit NFTListed(listingIdCounter, msg.sender, nftContract, tokenId, price);
    }

    function buyNFT(uint256 listingId) external payable nonReentrant {
        Listing storage listing = listings[listingId];

        require(listing.isActive,"Listing is not active");
        
        listing.isActive = false;
        
        IERC721(listing.nftContract).transferFrom(address(this),msg.sender,listing.tokenId);
        payable(listing.seller).transfer(msg.value);

        emit NFTSold(listingId, msg.sender, listing.nftContract, listing.tokenId, listing.price);
    }

    function cancelListing(uint256 listingId) external nonReentrant {
        Listing storage listing = listings[listingId];
        require(listing.isActive, "Listing is not active");
        require(listing.seller == msg.sender, "Only the seller can cancel the listing");

        listing.isActive = false;

        IERC721(listing.nftContract).transferFrom(address(this), listing.seller, listing.tokenId);

        emit ListingCanceled(listingId);
    }
}