// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Marketplace.sol";

contract CardMarketplace is Marketplace {
    constructor(address _cardNFT, uint256 _commissionPercent) Marketplace(_cardNFT, _commissionPercent) {}
}