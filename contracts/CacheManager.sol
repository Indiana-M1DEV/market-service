// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./CacheNFT.sol";

contract CacheManager {
    CacheNFT public cacheNFT;

    struct Cache {
        string name;
        string description;
        uint256 price;
        uint8 rarity;
        address owner;
        bool forSale;
    }

    mapping(uint256 => Cache) public caches;
    mapping(address => uint256[]) public userCaches;
    uint256 public cacheCounter;

    event CacheAdded(uint256 cacheId, address owner);
    event CacheRemoved(uint256 cacheId, address owner);

    modifier onlyOwner(uint256 _cacheId) {
        require(caches[_cacheId].owner == msg.sender, "You cannot alter that if you're not the owner.");
        _;
    }

    constructor(address _cacheNFT) {
        cacheNFT = CacheNFT(_cacheNFT);
    }

    function addCache(string memory _name, string memory _description, uint256 _price, uint8 _rarity, string memory tokenURI) public {
        require(_rarity >= 1 && _rarity <= 5, "Rarity must be between 1 and 5");

        cacheCounter++;
        cacheNFT.mint(msg.sender, tokenURI);
        caches[cacheCounter] = Cache(_name, _description, _price, _rarity, msg.sender, false);
        userCaches[msg.sender].push(cacheCounter);

        emit CacheAdded(cacheCounter, msg.sender);
    }

    function removeCache(uint256 _cacheId) public onlyOwner(_cacheId) {
        delete caches[_cacheId];

        uint256[] storage userCacheList = userCaches[msg.sender];
        for(uint256 i = 0; i < userCacheList.length; i++) {
            if(userCacheList[i] == _cacheId) {
                userCacheList[i] = userCacheList[userCacheList.length - 1];
                userCacheList.pop();
                break;
            }
        }

        emit CacheRemoved(_cacheId, msg.sender);
    }

    function getUserCaches(address _user) public view returns (uint256[] memory) {
        return userCaches[_user];
    }

    function getCacheDetails(uint256 _cacheId) public view returns (string memory, string memory, uint256, uint8, address, bool) {
        Cache memory cache = caches[_cacheId];
        return (cache.name, cache.description, cache.price, cache.rarity, cache.owner, cache.forSale);
    }

    function setForSale(uint256 _cacheId, uint256 _price) public onlyOwner(_cacheId) {
        caches[_cacheId].price = _price;
        caches[_cacheId].forSale = true;
    }
}