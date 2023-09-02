// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.16;

import {IOnchainCredentialStatusResolver} from "../interfaces/IOnchainCredentialStatusResolver.sol";
import {IState} from "../interfaces/IState.sol";
import {OnChainIdentity} from "../lib/OnChainIdentity.sol";
import {SmtLib} from "../lib/SmtLib.sol";

// /**
//  * @dev Contract managing onchain identity
//  */
contract IdentityBase is IOnchainCredentialStatusResolver {
    // This empty reserved space is put in place to allow future versions
    // of this contract to add new parent contracts without shifting down
    // storage of child contracts that use this contract as a base
    // (see https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable#storage-gaps)
    uint256[500] private __gapBefore;

    using OnChainIdentity for OnChainIdentity.Identity;

    OnChainIdentity.Identity internal identity;

    // This empty reserved space is put in place to allow future versions
    // of this contract to add new variables without shifting down
    // storage of child contracts that use this contract as a base
    // (see https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable#storage-gaps)
    uint256[49] private __gapAfter;

    /**
     * @dev Get configured Identity SMT depth.
     * @return depth of the SMT
     */
    function getSmtDepth() public pure virtual returns (uint256) {
        return 40;
    }

    /**
     * @dev Initialization of OnChainIdentity library
     * @param _stateContractAddr - address of the State contract
     */
    function initialize(address _stateContractAddr) public virtual {
        identity.initialize(_stateContractAddr, address(this), getSmtDepth());
    }

    /**
     * @dev Retrieve Claim inclusion or non-inclusion proof for a given claim index.
     * @param claimIndexHash - hash of Claim Index
     * @return The ClaimsTree inclusion or non-inclusion proof for the claim
     */
    function getClaimProof(
        uint256 claimIndexHash
    ) public view virtual returns (SmtLib.Proof memory) {
        return identity.getClaimProof(claimIndexHash);
    }

    /**
     * @dev Retrieve Claim inclusion or non-inclusion proof for a given claim index by target root.
     * @param claimIndexHash - hash of Claim Index
     * @param root - root of the tree
     * @return The ClaimsTree inclusion or non-inclusion proof for the claim
     */
    function getClaimProofByRoot(
        uint256 claimIndexHash,
        uint256 root
    ) public view virtual returns (SmtLib.Proof memory) {
        return identity.getClaimProofByRoot(claimIndexHash, root);
    }

    /**
     * @dev Retrieve ClaimsTree latest root.
     * @return The latest ClaimsTree root
     */
    function getClaimsTreeRoot() public view virtual returns (uint256) {
        return identity.getClaimsTreeRoot();
    }

    /**
     * @dev Retrieve inclusion or non-inclusion proof for a given revocation nonce.
     * @param revocationNonce - revocation nonce
     * @return The RevocationsTree inclusion or non-inclusion proof for the claim
     */
    function getRevocationProof(
        uint64 revocationNonce
    ) public view virtual returns (SmtLib.Proof memory) {
        return identity.getRevocationProof(revocationNonce);
    }

    /**
     * @dev Retrieve inclusion or non-inclusion proof for a given revocation nonce by target root.
     * @param revocationNonce - revocation nonce
     * @param root - root of the tree
     * @return The RevocationsTree inclusion or non-inclusion proof for the claim
     */
    function getRevocationProofByRoot(
        uint64 revocationNonce,
        uint256 root
    ) public view virtual returns (SmtLib.Proof memory) {
        return identity.getRevocationProofByRoot(revocationNonce, root);
    }

    /**
     * @dev Retrieve RevocationsTree latest root.
     * @return The latest RevocationsTree root
     */
    function getRevocationsTreeRoot() public view virtual returns (uint256) {
        return identity.getRevocationsTreeRoot();
    }

    /**
     * @dev Retrieve inclusion or non-inclusion proof for a given claimsTreeRoot.
     * @param claimsTreeRoot - claims tree root
     * @return The RevocationsTree inclusion or non-inclusion proof for the claim
     */
    function getRootProof(
        uint256 claimsTreeRoot
    ) public view virtual returns (SmtLib.Proof memory) {
        return identity.getRootProof(claimsTreeRoot);
    }

    /**
     * @dev Retrieve inclusion or non-inclusion proof for a given claimsTreeRoot by target root.
     * @param claimsTreeRoot - claims tree root
     * @param root - root of the tree
     * @return The RevocationsTree inclusion or non-inclusion proof for the claim
     */
    function getRootProofByRoot(
        uint256 claimsTreeRoot,
        uint256 root
    ) public view virtual returns (SmtLib.Proof memory) {
        return identity.getRootProofByRoot(claimsTreeRoot, root);
    }

    /**
     * @dev Retrieve RootsTree latest root.
     * @return The latest RootsTree root
     */
    function getRootsTreeRoot() public view virtual returns (uint256) {
        return identity.getRootsTreeRoot();
    }

    /**
     * @dev returns historical claimsTree roots, revocationsTree roots, rootsTree roots
     * by state
     * @param state identity state
     * @return set of roots
     */
    function getRootsByState(
        uint256 state
    ) public view virtual returns (OnChainIdentity.Roots memory) {
        return identity.getRootsByState(state);
    }

    /**
     * @dev returns identity Id
     * @return uint256 Id
     */
    function getId() public view returns (uint256) {
        return identity.id;
    }

    /**
     * @dev returns isOldStateGenesis flag
     * @return bool isOldStateGenesis
     */
    function getIsOldStateGenesis() public view returns (bool) {
        return identity.isOldStateGenesis;
    }

    /**
     * @dev returns last claims root
     * @return claimsRoot
     */
    function getLastClaimsRoot() public view returns (uint256) {
        return identity.lastTreeRoots.claimsRoot;
    }

    /**
     * @dev returns last revocation root
     * @return claimsRoot
     */
    function getLastRevocationsRoot() public view returns (uint256) {
        return identity.lastTreeRoots.revocationsRoot;
    }

    /**
     * @dev returns last roots root
     * @return rootsRoot
     */
    function getLastRootsRoot() public view returns (uint256) {
        return identity.lastTreeRoots.rootsRoot;
    }

    /**
     * @dev returns identity latest state
     * @return uint256 identityLatestState
     */
    function getIdentityLatestState() public view returns (uint256) {
        return identity.latestState;
    }

    /**
     * @dev returns revocation status of a claim using given revocation nonce
     * @param id Issuer's identifier
     * @param nonce Revocation nonce
     * @return CredentialStatus
     */
    function getRevocationStatus(
        uint256 id,
        uint64 nonce
    ) public view returns (CredentialStatus memory) {
        require(id == identity.id, "Identity id mismatch");
        uint256 latestState = identity.latestState;
        OnChainIdentity.Roots memory historicalStates = identity.getRootsByState(latestState);
        IdentityStateRoots memory issuerStates = IdentityStateRoots({
            state: latestState,
            rootOfRoots: historicalStates.rootsRoot,
            claimsTreeRoot: historicalStates.claimsRoot,
            revocationTreeRoot: historicalStates.revocationsRoot
        });

        SmtLib.Proof memory p = identity.getRevocationProofByRoot(
            nonce,
            historicalStates.revocationsRoot
        );
        Proof memory mtp = Proof({
            root: p.root,
            existence: p.existence,
            siblings: p.siblings,
            index: p.index,
            value: p.value,
            auxExistence: p.auxExistence,
            auxIndex: p.auxIndex,
            auxValue: p.auxValue
        });

        return CredentialStatus({issuer: issuerStates, mtp: mtp});
    }
}
