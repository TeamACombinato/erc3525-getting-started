# ERC3525 token issuance with polygon id

```shell
npx hardhat compile
npx hardhat run --network mumbai scripts/deploy.ts
```

Edit `polygonid.ts` using the deployed contract address.
By running `polygonid.ts`, we can set requests for verifications.

```shell
npx hardhat run --network mumbai scripts/polygonid.ts
```


<!-- # Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
``` -->
