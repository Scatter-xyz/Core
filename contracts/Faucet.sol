pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Faucet is ERC721{

    uint public tokenCount;
    uint public maxSupply;
    address public owner;

    constructor() ERC721("BoredApeYachtClub","BAYC") {
        tokenCount = 0;
        maxSupply = 5000;
        owner = msg.sender;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);
        return string(abi.encodePacked("ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/",Strings.toString(tokenId)));
    }

    function mintToken() public {
        tokenCount = tokenCount + 1;
        require(tokenCount <= maxSupply, "Max Supply Is Reached!!");
        super._mint(msg.sender, tokenCount);
    }

    function increaseSupply(uint supply) public {
        require(msg.sender == owner, "Only owner can increase supply!!");
        maxSupply = supply;
    }

}