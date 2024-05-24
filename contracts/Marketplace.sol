// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./CardManager.sol";

contract Marketplace is CardManager {
    uint256 public commissionPercent;

    event CardSold(uint256 cardId, address from, address to, uint256 price, uint256 commission);

    modifier isForSale(uint256 _cardId) {
        require(cards[_cardId].forSale, "Attempted to alter a card that is not listed for sale on the marketplace.");
        _;
    }

    constructor(address _cardNFT, uint256 _commissionPercent) CardManager(_cardNFT) {
        commissionPercent = _commissionPercent;
    }

    function buyCard(uint256 _cardId) public payable isForSale(_cardId) {
        Card storage card = cards[_cardId];
        require(msg.value == card.price, "Incorrect price sent!");

        uint256 commission = (msg.value * commissionPercent) / 100;
        uint256 sellerProceeds = msg.value - commission;

        address previousOwner = card.owner;
        card.owner = msg.sender;
        card.forSale = false;

        // Transfer card
        userCards[msg.sender].push(_cardId);
        removeUserCard(previousOwner, _cardId);

        // Transfer funds
        payable(previousOwner).transfer(sellerProceeds);
        payable(owner()).transfer(commission);

        emit CardSold(_cardId, previousOwner, msg.sender, card.price, commission);
    }

    function removeUserCard(address _user, uint256 _cardId) internal {
        uint256[] storage userCardList = userCards[_user];
        for(uint256 i = 0; i < userCardList.length; i++) {
            if(userCardList[i] == _cardId) {
                userCardList[i] = userCardList[userCardList.length - 1];
                userCardList.pop();
                break;
            }
        }
    }
}