// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

struct OwnershipProofOutput {
    bytes32 dataHash;
    bool isValid;
}

struct TransferValidityProofOutput {
    bytes32[] oldDataHashes;
    bytes32[] newDataHashes;
    bytes pubKey;
    bytes sealedKey;
    bool isValid;
}

interface IERC7857DataVerifier {
    /// @notice Verify ownership of data, the _proof prove: 
    ///         1. The pre-image of dataHashes
    /// @param _proof Proof generated by TEE/ZKP
    function verifyOwnership(
        bytes[] calldata _proof
    ) external view returns (OwnershipProofOutput[] memory);

    /// @notice Verify data transfer validity, the _proof prove: 
    ///         1. The pre-image of oldDataHashes
    ///         2. The oldKey can decrypt the pre-image and the new key re-encrypt the plaintexts to new ciphertexts
    ///         3. The newKey is encrypted using the receiver's pubKey
    ///         4. The hashes of new ciphertexts is newDataHashes
    ///         5. The newDataHashes identified ciphertexts are available in the storage: need the signature from the receiver signing oldDataHashes and newDataHashes
    /// @param _proof Proof generated by TEE/ZKP
    function verifyTransferValidity(
        bytes calldata _proof
    ) external view returns (TransferValidityProofOutput memory);
}