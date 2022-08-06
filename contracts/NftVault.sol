//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.9;

import '@openzeppelin/contracts/token/ERC721/IERC721.sol';

contract NftVault {

    address public owner;

    constructor()  {
        owner = msg.sender;
    }

    function transferNFT(address receiver, address _nftContractAddress, uint tokenId) external onlyOwner {
        IERC721 nftContractAddress = IERC721(_nftContractAddress);
        nftContractAddress.transferFrom(address(this), receiver, tokenId);
    }

    function updateOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    receive() external payable {}

    function destroy() external onlyOwner {
        selfdestruct(payable(owner));
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute it!!!");
        _;
    }

}