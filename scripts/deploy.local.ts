import { ethers } from "hardhat";
async function main() {
  const [owner] = await ethers.getSigners();
  // ref: https://zenn.dev/onsenengineer/articles/900efcbde5765e
  // ref: https://hardhat.org/hardhat-runner/docs/guides/deploying
  const gettingStarted = await ethers.deployContract("ERC3525GettingStarted", [owner.address]);
  gettingStarted.waitForDeployment();
  console.log(`GettingStarted deployed to ${gettingStarted.target}`);
  // const GettingStarted = await ethers.getContractFactory("ERC3525GettingStarted");
  // const gettingStarted = await GettingStarted.deploy(owner.address);
  // gettingStarted.deployed();
  // console.log(`GettingStarted deployed to ${gettingStarted.address}`);
}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
 console.error(error);
 process.exitCode = 1;
});