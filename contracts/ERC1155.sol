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

contract Marketplace is ReentrancyGuard {
    struct Listing {
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 amount;
        uint256 price;
        bool isActive;
    }

    mapping(uint256 => Listing) public listings;
    uint256 public listingIdCounter;

    // Events
    event NFTListed(uint256 indexed listingId, address indexed seller, address indexed nftContract, uint256 tokenId, uint256 amount, uint256 price);
    event NFTSold(uint256 indexed listingId, address indexed buyer, address indexed nftContract, uint256 tokenId, uint256 amount, uint256 price);
    event ListingCanceled(uint256 indexed listingId);

    // List an NFT for sale
    function listNFT(address nftContract, uint256 tokenId, uint256 amount, uint256 price) external nonReentrant {
        require(price > 0, "Price must be greater than 0");
        require(amount > 0, "Amount must be greater than 0");

        IERC1155(nftContract).safeTransferFrom(msg.sender, address(this), tokenId, amount, "");

        listingIdCounter++;
        listings[listingIdCounter] = Listing({
            seller: msg.sender,
            nftContract: nftContract,
            tokenId: tokenId,
            amount: amount,
            price: price,
            isActive: true
        });

        emit NFTListed(listingIdCounter, msg.sender, nftContract, tokenId, amount, price);
    }

    // Buy an NFT
    function buyNFT(uint256 listingId, uint256 amount) external payable nonReentrant {
        Listing storage listing = listings[listingId];
        require(listing.isActive, "Listing is not active");
        require(listing.amount >= amount, "Insufficient amount listed");
        require(msg.value >= listing.price * amount, "Insufficient payment");

        listing.amount -= amount;
        if (listing.amount == 0) {
            listing.isActive = false;
        }

        IERC1155(listing.nftContract).safeTransferFrom(address(this), msg.sender, listing.tokenId, amount, "");
        payable(listing.seller).transfer(msg.value);

        emit NFTSold(listingId, msg.sender, listing.nftContract, listing.tokenId, amount, listing.price);
    }

    // Cancel a listing
    function cancelListing(uint256 listingId) external nonReentrant {
        Listing storage listing = listings[listingId];
        require(listing.isActive, "Listing is not active");
        require(listing.seller == msg.sender, "Only the seller can cancel the listing");

        listing.isActive = false;
        IERC1155(listing.nftContract).safeTransferFrom(address(this), listing.seller, listing.tokenId, listing.amount, "");

        emit ListingCanceled(listingId);
    }

    // Buy multiple NFTs together
    function buyTogether(uint256[] calldata listingIds, uint256[] calldata amounts) external payable nonReentrant {
        require(listingIds.length == amounts.length, "Arrays length mismatch");

        uint256 totalCost = 0;

        // Calculate total cost and validate listings
        for (uint256 i = 0; i < listingIds.length; i++) {
            Listing storage listing = listings[listingIds[i]];
            require(listing.isActive, "Listing is not active");
            require(listing.amount >= amounts[i], "Insufficient amount listed");
            totalCost += listing.price * amounts[i];
        }

        require(msg.value >= totalCost, "Insufficient payment");

        // Transfer NFTs and update listings
        for (uint256 i = 0; i < listingIds.length; i++) {
            Listing storage listing = listings[listingIds[i]];
            listing.amount -= amounts[i];
            if (listing.amount == 0) {
                listing.isActive = false;
            }
            IERC1155(listing.nftContract).safeTransferFrom(address(this), msg.sender, listing.tokenId, amounts[i], "");
        }

        // Transfer payment to sellers
        payable(msg.sender).transfer(msg.value - totalCost); // Refund excess ETH
    }
}