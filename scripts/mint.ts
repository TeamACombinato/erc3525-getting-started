import { ethers } from "hardhat";
async function main() {
  const [owner] = await ethers.getSigners();
  const GettingStarted = await ethers.getContractFactory("ERC3525GettingStarted");
  const gettingStarted = await GettingStarted.attach('0x5FbDB2315678afecb367f032d93F642f64180aa3');
  const tx = await gettingStarted.mint(owner.address, 3525, 20220905);
  await tx.wait();
  const uri = await gettingStarted.tokenURI(1);
  console.log(uri);
}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});