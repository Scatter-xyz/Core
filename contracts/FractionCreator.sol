//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";

contract FractionCreator is ERC1155URIStorage {

    constructor(uint256 tokenId, string memory tokenURI, uint fractionCount, address nftSalesContract) ERC1155("") {
        _mint(nftSalesContract, tokenId, fractionCount, " ");
        setURI(tokenId, tokenURI);
    }

    function mintFraction(uint256 tokenId, string memory tokenURI, uint fractionCount, address nftSalesContract) external {
        _mint(nftSalesContract, tokenId, fractionCount, " ");
        setURI(tokenId, tokenURI);
    }

    function setURI(uint256 tokenId, string memory tokenURI) internal {
        super._setURI(tokenId, tokenURI);
    }

    //Remove in final build
    function destroy() public {
        selfdestruct(payable(msg.sender));
    }
}