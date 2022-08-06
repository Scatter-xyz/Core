// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const NFTVault = await hre.ethers.getContractFactory("NftVault");
  const nftVault = await NFTVault.deploy();

  await nftVault.deployed();

  console.log("NFT Vault is deployed to: ", nftVault.address);

  const FractionSale = await hre.ethers.getContractFactory("FractionSale");
  const fractionSale = await FractionSale.deploy();

  await fractionSale.deployed();

  console.log("Fraction Sale is deployed to: ", fractionSale.address);

  const Fraction = await hre.ethers.getContractFactory("Fraction");
  const fraction = await Fraction.deploy(fractionSale.address, nftVault.address);

  await fraction.deployed();

  console.log("fraction is deployed to: ", fraction.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
