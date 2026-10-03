//
//  CryptoManager.swift
//  CosmosApp
//
//  Layer 2 Cryptography: Apple CryptoKit AES-256 End-to-End Encryption (E2EE)
//

import Foundation
import CryptoKit

public struct EncryptedDataPackage: Codable, Equatable {
    public let ciphertextBase64: String
    public let nonceBase64: String
    public let tagBase64: String

    public init(ciphertextBase64: String, nonceBase64: String, tagBase64: String) {
        self.ciphertextBase64 = ciphertextBase64
        self.nonceBase64 = nonceBase64
        self.tagBase64 = tagBase64
    }
}

public class CryptoManager {
    public static let shared = CryptoManager()
    private let keyService = "com.cosmos.e2ee.keys"
    private let keyAccount = "primary_symmetric_key"

    private var primarySymmetricKey: SymmetricKey?

    private init() {
        self.primarySymmetricKey = loadOrGenerateKey()
    }

    // MARK: - Key Management

    private func loadOrGenerateKey() -> SymmetricKey {
        if let storedKeyData = KeychainHelper.shared.read(service: keyService, account: keyAccount) {
            return SymmetricKey(data: storedKeyData)
        }

        let newKey = SymmetricKey(size: .bits256)
        let rawKeyData = newKey.withUnsafeBytes { Data(Array($0)) }
        _ = KeychainHelper.shared.save(rawKeyData, service: keyService, account: keyAccount)
        AppLogger.shared.log("Generated and securely saved new 256-bit AES SymmetricKey to Keychain", level: .security)
        return newKey
    }

    public func deriveKeyFromSharedSecret(_ sharedSecret: Data, salt: Data) -> SymmetricKey {
        let inputKeyMaterial = SymmetricKey(data: sharedSecret)
        return HKDF<SHA256>.deriveKey(
            inputKeyMaterial: inputKeyMaterial,
            salt: salt,
            info: Data("CosmosE2EEKeyDerivation".utf8),
            outputByteCount: 32
        )
    }

    // MARK: - AES-256-GCM Encryption

    public func encrypt(plaintext: String, key: SymmetricKey? = nil) throws -> EncryptedDataPackage {
        guard let data = plaintext.data(using: .utf8) else {
            throw NSError(domain: "CryptoManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid UTF-8 string"])
        }
        return try encryptData(data: data, key: key)
    }

    public func encryptData(data: Data, key: SymmetricKey? = nil) throws -> EncryptedDataPackage {
        let encryptionKey = key ?? (primarySymmetricKey ?? loadOrGenerateKey())
        let sealedBox = try AES.GCM.seal(data, using: encryptionKey)

        let ciphertextBase64 = sealedBox.ciphertext.base64EncodedString()
        let nonceBase64 = Data(sealedBox.nonce).base64EncodedString()
        let tagBase64 = sealedBox.tag.base64EncodedString()

        return EncryptedDataPackage(
            ciphertextBase64: ciphertextBase64,
            nonceBase64: nonceBase64,
            tagBase64: tagBase64
        )
    }

    // MARK: - AES-256-GCM Decryption

    public func decrypt(package: EncryptedDataPackage, key: SymmetricKey? = nil) throws -> String {
        let decryptedData = try decryptData(package: package, key: key)
        guard let string = String(data: decryptedData, encoding: .utf8) else {
            throw NSError(domain: "CryptoManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to decode UTF-8 string"])
        }
        return string
    }

    public func decryptData(package: EncryptedDataPackage, key: SymmetricKey? = nil) throws -> Data {
        let decryptionKey = key ?? (primarySymmetricKey ?? loadOrGenerateKey())

        guard let ciphertext = Data(base64Encoded: package.ciphertextBase64),
              let nonceData = Data(base64Encoded: package.nonceBase64),
              let tagData = Data(base64Encoded: package.tagBase64) else {
            throw NSError(domain: "CryptoManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid Base64 encoded payload"])
        }

        let nonce = try AES.GCM.Nonce(data: nonceData)
        let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tagData)
        return try AES.GCM.open(sealedBox, using: decryptionKey)
    }
}
