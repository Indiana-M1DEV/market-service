// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./CardNFT.sol";

contract CardManager {
    CardNFT public cardNFT;

    struct Card {
        string name;
        string description;
        uint256 price;
        uint8 rarity;
        address owner;
        bool forSale;
    }

    mapping(uint256 => Card) public cards;
    mapping(address => uint256[]) public userCards;
    uint256 public cardCounter;

    event CardAdded(uint256 cardId, address owner);
    event CardRemoved(uint256 cardId, address owner);

    modifier onlyOwner(uint256 _cardId) {
        require(cards[_cardId].owner == msg.sender, "You cannot alter that if you're not the owner.");
        _;
    }

    constructor(address _cardNFT) {
        cardNFT = CardNFT(_cardNFT);
    }

    function addCard(string memory _name, string memory _description, uint256 _price, uint8 _rarity, string memory tokenURI) public {
        require(_rarity >= 1 && _rarity <= 5, "Rarity must be between 1 and 5");

        cardCounter++;
        cardNFT.mint(msg.sender, tokenURI);
        cards[cardCounter] = Card(_name, _description, _price, _rarity, msg.sender, false);
        userCards[msg.sender].push(cardCounter);

        emit CardAdded(cardCounter, msg.sender);
    }

    function removeCard(uint256 _cardId) public onlyOwner(_cardId) {
        delete cards[_cardId];

        uint256[] storage userCardList = userCards[msg.sender];
        for(uint256 i = 0; i < userCardList.length; i++) {
            if(userCardList[i] == _cardId) {
                userCardList[i] = userCardList[userCardList.length - 1];
                userCardList.pop();
                break;
            }
        }

        emit CardRemoved(_cardId, msg.sender);
    }

    function getUserCards(address _user) public view returns (uint256[] memory) {
        return userCards[_user];
    }

    function getCardDetails(uint256 _cardId) public view returns (string memory, string memory, uint256, uint8, address, bool) {
        Card memory card = cards[_cardId];
        return (card.name, card.description, card.price, card.rarity, card.owner, card.forSale);
    }

    function setForSale(uint256 _cardId, uint256 _price) public onlyOwner(_cardId) {
        cards[_cardId].price = _price;
        cards[_cardId].forSale = true;
    }
}