//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Mint is ERC721URIStorage{

    uint public tokenCount;
    uint public maxSupply;
    address public owner;

    constructor() ERC721("CreateYourOwnNFT","CYON") {
        tokenCount = 0;
        maxSupply = 100000000000000;
        owner = msg.sender;
    }

    function mintToken(string memory ipfs) public {
        tokenCount = tokenCount + 1;
        require(tokenCount <= maxSupply, "Max Supply Is Reached!!");
        super._mint(msg.sender, tokenCount);
        super._setTokenURI(tokenCount, ipfs);
    }

}