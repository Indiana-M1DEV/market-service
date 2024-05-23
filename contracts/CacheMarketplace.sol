// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Marketplace.sol";

contract CacheMarketplace is Marketplace {
    constructor(address _cacheNFT, uint256 _commissionPercent) Marketplace(_cacheNFT, _commissionPercent) {}
}