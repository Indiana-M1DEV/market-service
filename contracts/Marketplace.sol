// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./CacheManager.sol";

contract Marketplace is CacheManager {
    uint256 public commissionPercent;

    event CacheSold(uint256 cacheId, address from, address to, uint256 price, uint256 commission);

    modifier isForSale(uint256 _cacheId) {
        require(caches[_cacheId].forSale, "Attempted to alter a cache that is not listed for sale on the marketplace.");
        _;
    }

    constructor(address _cacheNFT, uint256 _commissionPercent) CacheManager(_cacheNFT) {
        commissionPercent = _commissionPercent;
    }

    function buyCache(uint256 _cacheId) public payable isForSale(_cacheId) {
        Cache storage cache = caches[_cacheId];
        require(msg.value == cache.price, "Incorrect price sent!");

        uint256 commission = (msg.value * commissionPercent) / 100;
        uint256 sellerProceeds = msg.value - commission;

        address previousOwner = cache.owner;
        cache.owner = msg.sender;
        cache.forSale = false;

        // Transfer cache
        userCaches[msg.sender].push(_cacheId);
        removeUserCache(previousOwner, _cacheId);

        // Transfer funds
        payable(previousOwner).transfer(sellerProceeds);
        payable(owner()).transfer(commission);

        emit CacheSold(_cacheId, previousOwner, msg.sender, cache.price, commission);
    }

    function removeUserCache(address _user, uint256 _cacheId) internal {
        uint256[] storage userCacheList = userCaches[_user];
        for(uint256 i = 0; i < userCacheList.length; i++) {
            if(userCacheList[i] == _cacheId) {
                userCacheList[i] = userCacheList[userCacheList.length - 1];
                userCacheList.pop();
                break;
            }
        }
    }
}