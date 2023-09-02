import { ethers } from "hardhat";

async function main() {
    const verifierContract = "ERC3525GettingStarted";
    const ownerAddr = "0x1d1f4882Da564c04e310eBABA6836ac33517E60a";

//   const spongePoseidonLib = "0x12d8C87A61dAa6DD31d8196187cFa37d1C647153";
//   const poseidon6Lib = "0xb588b8f07012Dc958aa90EFc7d3CF943057F17d7";

  const ERC3525Verifier = await ethers.getContractFactory(verifierContract, {
    libraries: {
    //   SpongePoseidon: spongePoseidonLib,
    //   PoseidonUnit6L: poseidon6Lib,
    PoseidonFacade: "0x2Cc81096be34f2eE4df0f4d8C3fBe1d92cFB5f5d", // $ npx hardhat run --network mumbai scripts/deployPoseidon.ts の結果を引く
    },
  });
  const erc3525Verifier = await ERC3525Verifier.deploy(
    ownerAddr,
    );

  console.log("Deploying ", " contract...");
  await erc3525Verifier.waitForDeployment();
  console.log("contract address:", erc3525Verifier.target);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

/*
メモ: ライブラリのアドレスを見つけるためにiden3/contract/scripts/ 配下の中で以下を実行
最後にdeployされた PoseidonFacade のアドレスを使う

$ npx hardhat run --network mumbai scripts/deploy.ts

[ '======== State: deploy started ========' ]
[ 'found defaultIdType 0x0212 for chainId 80001' ]
[ 'deploying verifier...' ]
[
  'VerifierStateTransition contract deployed to address 0xDd538D8589B0409440817f29955a8A4a9e1433F3 from 0x1d1f4882Da564c04e310eBABA6836ac33517E60a'
]
[ 'deploying poseidons...' ]
Poseidon1Elements deployed to: 0x761A991425E12Cd999B3c4B858D5387501fd4abE
Poseidon2Elements deployed to: 0x3E48d5A1528295834eeC1DcF9aadadE00135A32d
Poseidon3Elements deployed to: 0xd841997844e1Fb9CD104D8921B299c983dAe2E07
Poseidon4Elements deployed to: 0xE4be2fd1F5b7338d6C6fD8207C3Efa880c0111d7
[ 'deploying SmtLib...' ]
[ 'SmtLib deployed to:  0xc956a5C5E5c42Ce2fa5bE5D6aD49526c5cCBdc8B' ]
[ 'deploying StateLib...' ]
[ 'StateLib deployed to:  0x04011c07D9F4916e2977DBdE1197C8f2A82a5aAF' ]
[ 'deploying state...' ]
Warning: Potentially unsafe deployment of contracts/state/State.sol:State

    You are using the `unsafeAllow.external-library-linking` flag to include external libraries.
    Make sure you have manually checked that the linked libraries are upgrade safe.

[
  'State contract deployed to address 0x048fdE0b62567bF0c6F8E13c64A55079AD061EaF from 0x1d1f4882Da564c04e310eBABA6836ac33517E60a'
]
[ '======== State: deploy completed ========' ]

$ npx hardhat run --network mumbai scripts/deployPoseidon.ts

Generating typings for: 50 artifacts in dir: typechain for target: ethers-v5
Successfully generated 91 typings!
Compiled 42 Solidity files successfully
Poseidon1Elements deployed to: 0xB0aE407AdEb87C02C8a0fD0daEA6aAeB78FC9987
Poseidon2Elements deployed to: 0x04236769343AC3eFB75F1baD3Dd85002aa69b364
Poseidon3Elements deployed to: 0x0cBfbc89361450f7ED65F50837E39F482E6a94f1
Poseidon4Elements deployed to: 0x1595eAA8750a92d94a20a71c2E8d63B27ebDad17
Poseidon5Elements deployed to: 0x26A53Fd01323F1F45Ac4fEA261A91BF7B14586f0
Poseidon6Elements deployed to: 0x8086E3e8709D0422f3e3e447C0B308311798deA7
SpongePoseidon deployed to: 0x3d71006De68420b5853b6E680FD24e6AC88fbe3f
PoseidonFacade deployed to: 0x2Cc81096be34f2eE4df0f4d8C3fBe1d92cFB5f5d
*/