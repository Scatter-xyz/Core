//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.9;

import './FractionCreator.sol';
import "./NftVault.sol";
import "./FractionSale.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Fraction {

    address public owner;
    NftVault public nftVaultContract;
    mapping(address => address) fractionalisedNFTs;
    uint public MAX_FRACTION_COUNT = 1000;

    constructor(address payable _nftVaultContract) {
        owner = msg.sender;
        nftVaultContract = NftVault(_nftVaultContract);
    }

    function fractionalize(address _nftContractAddress, uint256 tokenId, uint fractionCount) external{
        ERC721 nftContract = ERC721(_nftContractAddress);

        //Max Fraction Count Allowed
        require(fractionCount <= MAX_FRACTION_COUNT, string(bytes.concat(bytes("Max fractions allowed: "), bytes(Strings.toString(MAX_FRACTION_COUNT)))));
        
        //Check if the contract has the access to tranfer the NFT to Vault
        require(nftContract.getApproved(tokenId) == address(this),"NFT not approved for transfer");

        //Transfer the token to safe Vault
        nftContract.transferFrom(msg.sender, address(nftVaultContract), tokenId);
        
        //Creating Logo and Symbol for the collection
        string memory logo = string(bytes.concat(bytes(nftContract.symbol()), bytes("-FXN-"), bytes(Strings.toString(tokenId))));
        string memory symbol = string(bytes.concat(bytes(nftContract.name()), bytes("Fractinalised")));

        FractionCreator fractionCollection;
        
        if(fractionalisedNFTs[_nftContractAddress] == address(0)) {
            //Generate Fractionalised NFT Contract
            FractionCreator newFractionCollection = new FractionCreator(tokenId, nftContract.tokenURI(tokenId), fractionCount, msg.sender);
            fractionalisedNFTs[_nftContractAddress] = address(newFractionCollection);
            fractionCollection = newFractionCollection;
        } else {
            //Take exising NFT contract and mint new one
            fractionCollection = FractionCreator(fractionalisedNFTs[_nftContractAddress]);
            fractionCollection.mintFraction(tokenId, nftContract.tokenURI(tokenId), fractionCount, msg.sender);
        }

    }

    function upgradeNFTContract(address payable _newnftVaultContract) external onlyOwner{
        nftVaultContract = NftVault(_newnftVaultContract);
    }

    function destroy() public onlyOwner {
        selfdestruct(payable(owner));
    }

    receive() external payable {}

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized!!!");
        _;
    }
}
