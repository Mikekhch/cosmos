//
//  Message.swift
//  CosmosApp
//
//  Production Model for Spatial Chat & E2EE Messages
//

import Foundation

public struct Message: Identifiable, Codable, Equatable {
    public let id: String
    public let senderId: String
    public let recipientId: String
    public let encryptedContent: String // Base64 encoded AES-256-GCM ciphertext
    public let nonce: String            // Base64 encoded AES-GCM nonce
    public let authTag: String          // Base64 encoded AES-GCM authentication tag
    public let timestamp: Date
    public var isDecryptedLocally: Bool
    public var plaintextOverride: String? // Unencrypted content when decrypted in memory only

    public init(
        id: String = UUID().uuidString,
        senderId: String,
        recipientId: String,
        encryptedContent: String,
        nonce: String,
        authTag: String,
        timestamp: Date = Date(),
        isDecryptedLocally: Bool = false,
        plaintextOverride: String? = nil
    ) {
        self.id = id
        self.senderId = senderId
        self.recipientId = recipientId
        self.encryptedContent = encryptedContent
        self.nonce = nonce
        self.authTag = authTag
        self.timestamp = timestamp
        self.isDecryptedLocally = isDecryptedLocally
        self.plaintextOverride = plaintextOverride
    }
}
