// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CacheNFT is ERC721URIStorage, Ownable {
    uint256 public nextTokenId;

    constructor() ERC721("CacheNFT", "CNFT") {}

    function mint(address to, string memory tokenURI) public onlyOwner {
        uint256 tokenId = nextTokenId;
        _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        nextTokenId++;
    }
}