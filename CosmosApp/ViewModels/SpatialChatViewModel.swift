//
//  SpatialChatViewModel.swift
//  CosmosApp
//
//  ViewModel for E2EE Spatial Chat & Messenger (Binaural Call Telemetry, AR Viewport, Sentiment Stream, VIP Drop)
//

import Foundation
import Combine
import SwiftUI

public struct ChatMessageSentiment: Identifiable {
    public let id: String
    public let authorName: String
    public let authorHandle: String
    public let timeString: String
    public let textContent: String
    public let sentimentTag: String
    public let sentimentColor: Color
    public let isVoiceNote: Bool
    public let voiceDurationSeconds: Int?
    public var reactions: [String: Int]
}

public class SpatialChatViewModel: ObservableObject {
    @Published public var messages: [Message] = []
    @Published public var messageInput: String = ""
    @Published public var isE2EEActive: Bool = true

    // Call Telemetry
    @Published public var isMicMuted: Bool = false
    @Published public var isSpatialAudio3DActive: Bool = true
    @Published public var connectedPeersCount: Int = 4
    @Published public var latencyMs: Int = 8
    @Published public var selectedCallTab: String = "HUD Call (Live)"

    // Persona & Viewport
    @Published public var activePersona: String = "Dr. Thorne (AI)"

    // In-Chat VIP Ticket Drop
    @Published public var ticketsRemaining: Int = 7
    @Published public var userHasMintedPass: Bool = false

    // Voice Note Player
    @Published public var isVoicePlaying: Bool = false
    @Published public var voiceSeconds: Int = 11
    @Published public var voiceTotalSeconds: Int = 24
    private var voiceTimer: AnyCancellable?

    // Real-Time Sync & Remote Config State
    @Published public var syncStatus: SyncStatus = .synced
    @Published public var syncErrorMessage: String? = nil
    @Published public var isE2EESpatialChatEnabled: Bool = true

    // Rich Sentiment Messages
    @Published public var sentimentMessages: [ChatMessageSentiment] = [
        ChatMessageSentiment(
            id: "1",
            authorName: "Kira Vance",
            authorHandle: "@kira.spatial",
            timeString: "22:19",
            textContent: "The spatial acoustics in the runway stream are surreal! Who is grabbing VIP backstage tickets? Node drop is live right now! ✨",
            sentimentTag: "Excited",
            sentimentColor: ObsidianTheme.primaryCyan,
            isVoiceNote: false,
            voiceDurationSeconds: nil,
            reactions: ["⚡": 4, "✨": 3]
        ),
        ChatMessageSentiment(
            id: "2",
            authorName: "Dr. Thorne (Synth AI)",
            authorHandle: "@thorne.ai",
            timeString: "22:20",
            textContent: "Acoustic refraction analysis indicates 99.4% binaural authenticity. Smart contract verification confirms pass redemption guarantees front-row spatial anchor privileges.",
            sentimentTag: "Analytical",
            sentimentColor: ObsidianTheme.secondaryIndigo,
            isVoiceNote: false,
            voiceDurationSeconds: nil,
            reactions: ["🤖": 5]
        ),
        ChatMessageSentiment(
            id: "3",
            authorName: "Ren_K",
            authorHandle: "@ren.k",
            timeString: "00:24",
            textContent: "Hey team, I just staked 50 $L2E for the backstage pass. Meet me at Sector 4 when the runway starts.",
            sentimentTag: "Voice Note",
            sentimentColor: ObsidianTheme.tertiaryEmerald,
            isVoiceNote: true,
            voiceDurationSeconds: 24,
            reactions: ["👍": 4, "⚡": 2, "🎟️": 1]
        )
    ]

    private var cancellables = Set<AnyCancellable>()

    public init() {
        bindServices()
        loadSampleMessages()
    }

    private func bindServices() {
        FirestoreSyncService.shared.$syncStatus
            .assign(to: &$syncStatus)

        FirestoreSyncService.shared.$errorMessage
            .assign(to: &$syncErrorMessage)

        RemoteConfigManager.shared.$isE2EESpatialChatEnabled
            .assign(to: &$isE2EESpatialChatEnabled)
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

                let newSentiment = ChatMessageSentiment(
                    id: UUID().uuidString,
                    authorName: "You (Sovereign Node)",
                    authorHandle: "@me",
                    timeString: "Just now",
                    textContent: textToSend,
                    sentimentTag: "E2EE Encrypted",
                    sentimentColor: ObsidianTheme.tertiaryEmerald,
                    isVoiceNote: false,
                    voiceDurationSeconds: nil,
                    reactions: [:]
                )
                self.sentimentMessages.append(newSentiment)
            }

            // AI Surveillance Anomaly Check
            _ = AnomalyDetectionEngine.shared.recordAndAnalyzeMessageSend(payloadSizeBytes: Int64(textToSend.utf8.count))
        } catch {
            AppLogger.shared.log("Failed to encrypt message: \(error.localizedDescription)", level: .error)
        }
    }

    public func toggleMic() {
        isMicMuted.toggle()
    }

    public func toggleSpatialAudio() {
        isSpatialAudio3DActive.toggle()
    }

    public func mintPass() {
        if ticketsRemaining > 0 {
            ticketsRemaining -= 1
            userHasMintedPass = true
        }
    }

    public func toggleVoicePlay() {
        isVoicePlaying.toggle()
        if isVoicePlaying {
            voiceTimer = Timer.publish(every: 1.0, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    if self.voiceSeconds < self.voiceTotalSeconds {
                        self.voiceSeconds += 1
                    } else {
                        self.voiceSeconds = 0
                        self.isVoicePlaying = false
                        self.voiceTimer?.cancel()
                    }
                }
        } else {
            voiceTimer?.cancel()
        }
    }

    public func addReaction(messageId: String, emoji: String) {
        if let idx = sentimentMessages.firstIndex(where: { $0.id == messageId }) {
            let count = sentimentMessages[idx].reactions[emoji] ?? 0
            sentimentMessages[idx].reactions[emoji] = count + 1
        }
    }
}
