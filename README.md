# ERC3525 token issuance with polygon id

## Preparation

```shell
npx hardhat compile
npx hardhat run --network mumbai scripts/deploy.ts
```

Edit `polygonid.ts` using the deployed contract address.
By running `polygonid.ts`, we can set requests for verifications.

```shell
npx hardhat run --network mumbai scripts/polygonid.ts
```

## Main Functions and Purposes
- `register`
For offices (like stores, servicers) which receive tokens as the payment from users, one can be registered without no verification (for now).
One must choose the slot for register, and only once is valid.

- `mint`
For mangagers, one can issue arbitrary amount of tokens to verified users.

- `tokenURI`
For everyone, one can check the tokenURI.
tokenURI is just the string of svg image, and this includes the information of the deginated token.

- `transfer`
For users who own the tokens, one can pay the token to registered offices.

- `setZKPRequest`
For managers, one can set up the airdrop of the deginated slot.
It can be done by `scripts/polygonid.ts`.

- `submitZKPResponse`
For users, one can submit the proof that proves one have the deginated VC.
When one submit the proof, one can get specific amount of token.

## Details
- iden3
    - We basically used the repo as of 2023/08/27
        - https://github.com/iden3/contracts/tree/860b3acb144515c45593053e8b05ae80afcefdf9
    - Only to deploy the library `PoseidonFacade`, we use the repo as of 2023/08/30
        - https://github.com/iden3/contracts/tree/75d19d56a9753e2e720f9486a18aafbf0c0e470a


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
