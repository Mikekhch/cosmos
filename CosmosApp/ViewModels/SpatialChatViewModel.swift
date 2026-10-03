//
//  SpatialChatViewModel.swift
//  CosmosApp
//
//  ViewModel for E2EE Spatial Chat & Messages
//

import Foundation
import Combine

public class SpatialChatViewModel: ObservableObject {
    @Published public var messages: [Message] = []
    @Published public var messageInput: String = ""
    @Published public var isE2EEActive: Bool = true

    public init() {
        loadSampleMessages()
    }

    private func loadSampleMessages() {
        let sample1 = "Welcome to Cosmos Spatial Network."
        if let pkg1 = try? CryptoManager.shared.encrypt(plaintext: sample1) {
            let msg1 = Message(
                senderId: "USR-COMM-01",
                recipientId: "CURRENT_USER",
                encryptedContent: pkg1.ciphertextBase64,
                nonce: pkg1.nonceBase64,
                authTag: pkg1.tagBase64,
                isDecryptedLocally: true,
                plaintextOverride: sample1
            )
            messages.append(msg1)
        }
    }

    public func sendEncryptedMessage() {
        guard !messageInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let textToSend = messageInput
        messageInput = ""

        do {
            let package = try CryptoManager.shared.encrypt(plaintext: textToSend)
            let message = Message(
                senderId: "CURRENT_USER",
                recipientId: "USR-COMM-01",
                encryptedContent: package.ciphertextBase64,
                nonce: package.nonceBase64,
                authTag: package.tagBase64,
                isDecryptedLocally: true,
                plaintextOverride: textToSend
            )

            DispatchQueue.main.async {
                self.messages.append(message)
            }

            // AI Surveillance Anomaly Check
            _ = AnomalyDetectionEngine.shared.recordAndAnalyzeMessageSend(payloadSizeBytes: Int64(textToSend.utf8.count))
        } catch {
            AppLogger.shared.log("Failed to encrypt message: \(error.localizedDescription)", level: .error)
        }
    }
}
