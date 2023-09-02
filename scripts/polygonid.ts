import { ethers } from "hardhat";

const Operators = {
  NOOP: 0, // No operation, skip query verification in circuit
  EQ: 1, // equal
  LT: 2, // less than
  GT: 3, // greater than
  IN: 4, // in
  NIN: 5, // not in
  NE: 6, // not equal
};

async function main() {
  // you can run https://go.dev/play/p/rnrRbxXTRY6 to get schema hash and claimPathKey using YOUR schema
  const schemaBigInt = "32837399553053075611746513170377359823";

  // merklized path to field in the W3C credential according to JSONLD  schema e.g. birthday in the KYCAgeCredential under the url "https://raw.githubusercontent.com/iden3/claim-schema-vocab/main/schemas/json-ld/kyc-v3.json-ld"
  const schemaClaimPathKey =
    "7159139046775413824063137455114119121050918171813317701385724846648277170181";

  // add the address of the contract just deployed
  const ERC3525VerifierAddress = "0xA2375aD738cd14f45b16bd09705f10D9ac901630"; // ここはdeploy.tsの結果を引く

  let erc3525Verifier = await ethers.getContractAt(
    "ERC3525GettingStarted",
    ERC3525VerifierAddress
  );

//   const validatorAddress = "0xF2D4Eeb4d455fb673104902282Ce68B9ce4Ac450"; // sig validator original
//   const validatorAddress = "0x3DcAe4c8d94359D31e4C89D7F2b944859408C618"; // mtp validator original
    // const validatorAddress = "0xe63d5fD3d2E66dd31ec2D339f988847B3310523E"; // mtp validator new
    const validatorAddress = "0x9953827b9A2A84Ce7B63672645516EfFc7031c6C"; // sig validator new

    for (let id = 1; id <= 23; id++) {
        const query = {
            schema: schemaBigInt,
            claimPathKey: schemaClaimPathKey,
            operator: Operators.EQ, // operator
            value: [id, ...new Array(63).fill(0).map((i) => 0)], // for operators 1-3 only first value matters
        };
        try {
            await erc3525Verifier.setZKPRequest(
                id,
                validatorAddress,
                query.schema,
                query.claimPathKey,
                query.operator,
                query.value
            );
            console.log("Request set: ", id);
        } catch (e) {
            console.log("error: ", e);
        }
    }
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

/*
$ npx hardhat run --network mumbai scripts/deployValidators.ts
No need to generate any newer typings.
Validator Verifier Wrapper deployed to: 0x47FA2Ff9B640DAeF936c1E8789b3c342DaE08448
CredentialAtomicQueryMTPValidator deployed to: 0xe63d5fD3d2E66dd31ec2D339f988847B3310523E
Validator Verifier Wrapper deployed to: 0xf8cfF3bD972Fe721Cce3F4829Ce909c2dB9EFFd4
CredentialAtomicQuerySigValidator deployed to: 0x9953827b9A2A84Ce7B63672645516EfFc7031c6C
*/