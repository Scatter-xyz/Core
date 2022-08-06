//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract FractionSale is ERC1155Holder {

    address public owner;

    struct FractionDetails {
        address originalContract;
        uint256 tokenId;
        address fractionContract;
        uint fractionCount;
        uint256[] availableFractions;
    }

    struct NFTContractDetail {
        address originalContract;
        uint256 tokenId;
    }

    address[] fractionAddresses;

    mapping(address => address) private originalContractToFractionMapping;

    mapping(address => NFTContractDetail[]) private fractionOriginalContactMapping;

    mapping(string => FractionDetails) private fractionContactDetail;

    mapping(address => address) private ownerFraction;

    constructor() {
        owner = msg.sender;
    }

    function storeFractionDetails(address originalContract, uint256 tokenId, address fractionContract, uint fractionCount) public {
        //Creating a mapping of owner and fraction contract
        ownerFraction[msg.sender] = fractionContract;

        fractionAddresses.push(fractionContract);

        originalContractToFractionMapping[originalContract] = fractionContract;


        NFTContractDetail memory nftContractDetails = NFTContractDetail(originalContract, tokenId);
        fractionOriginalContactMapping[fractionContract].push(nftContractDetails);

        uint256[] memory availableFractions;

        for(uint i=0; i<fractionCount; i++) {
            availableFractions[i] = i;
        }

        string memory fractionOriginalContractKey = string(bytes.concat(bytes(Strings.toHexString(uint160(originalContract), 20)), bytes("-"), bytes(Strings.toString(tokenId))));
        fractionContactDetail[fractionOriginalContractKey] = FractionDetails(originalContract, tokenId, fractionContract, fractionCount, availableFractions);

    }


    function transferToOwner(address fractionContract, uint256 fractionTokenId) public onlyOwner {

        IERC721 fractionContractParced = IERC721(fractionContract);

        require(fractionContractParced.ownerOf(fractionTokenId) == address(this), "NFT sold out in Sale!!");

        fractionContractParced.transferFrom(address(this), owner, fractionTokenId);

    } 

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized!!!");
        _;
    }

    function destroy() public onlyOwner {
        selfdestruct(payable(owner));
    }
    
}