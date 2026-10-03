//
//  HomeFeedViewModel.swift
//  CosmosApp
//
//  ViewModel for Home Feed screen (Spatial Cortex, $L2E Vault HUD, AR Spatial Canvas Feed)
//

import SwiftUI
import Combine

public enum FeedMode: String, CaseIterable, Identifiable {
    case spatial = "Spatial Map"
    case video = "Video Feed"
    case articles = "Articles"

    public var id: String { self.rawValue }

    public var iconName: String {
        switch self {
        case .spatial: return "view.in.ar"
        case .video: return "play.circle.fill"
        case .articles: return "book.fill"
        }
    }
}

public struct VoiceComment: Identifiable {
    public let id: String
    public let authorHandle: String
    public let durationSeconds: Int
    public let textSnippet: String
    public var currentPlaybackSeconds: Int
}

public final class HomeFeedViewModel: ObservableObject {
    @Published public var isSummaryExpanded: Bool = false
    @Published public var selectedFeedMode: FeedMode = .spatial
    @Published public var vaultBalanceL2E: Double = 1420.50
    @Published public var hourlyL2ERate: Double = 12.4
    @Published public var dailyQuestCompleted: Int = 2
    @Published public var dailyQuestTotal: Int = 3

    // Post 1 (Echoes of Shibuya)
    @Published public var donationFundRaisedToday: Double = 342.50
    @Published public var userDonatedAmount: Double = 0.0
    @Published public var isVoiceNotePlaying: Bool = false
    @Published public var voiceNoteCurrentSeconds: Int = 14
    @Published public var voiceNoteTotalSeconds: Int = 38
    private var voiceTimer: AnyCancellable?

    // Post 2 (Decentralized Spatial Web)
    @Published public var echoCount: Int = 142
    @Published public var isResonated: Bool = false

    public init() {}

    public func toggleSummary() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            isSummaryExpanded.toggle()
        }
    }

    public func selectFeedMode(_ mode: FeedMode) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            selectedFeedMode = mode
        }
    }

    public func donateToFund(amount: Double = 0.50) {
        userDonatedAmount += amount
        donationFundRaisedToday += amount
        vaultBalanceL2E += 1.0 // Reward user with $L2E for supporting conservation
    }

    public func toggleVoiceNotePlayback() {
        isVoiceNotePlaying.toggle()
        if isVoiceNotePlaying {
            voiceTimer = Timer.publish(every: 1.0, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    if self.voiceNoteCurrentSeconds < self.voiceNoteTotalSeconds {
                        self.voiceNoteCurrentSeconds += 1
                    } else {
                        self.voiceNoteCurrentSeconds = 0
                        self.isVoiceNotePlaying = false
                        self.voiceTimer?.cancel()
                    }
                }
        } else {
            voiceTimer?.cancel()
        }
    }

    public func tipCreatorL2E(amount: Double = 5.0) {
        if vaultBalanceL2E >= amount {
            vaultBalanceL2E -= amount
            echoCount += 1
        }
    }

    public func toggleResonate() {
        isResonated.toggle()
    }
}
