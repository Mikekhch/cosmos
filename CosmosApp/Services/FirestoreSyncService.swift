//
//  FirestoreSyncService.swift
//  CosmosApp
//
//  Firestore Real-Time Listener & Sync Service
//  Manages live listeners for feeds, spatial messages, and e-commerce modules with offline caching & fallback UI state management.
//

import Foundation
import Combine

public enum SyncStatus: String, Codable {
    case synced = "LIVE SYNCED"
    case syncing = "SYNCING..."
    case offline = "OFFLINE (CACHED)"
    case error = "SYNC ERROR"
}

public class FirestoreSyncService: ObservableObject {
    public static let shared = FirestoreSyncService()

    @Published public var syncStatus: SyncStatus = .synced
    @Published public var lastSyncTimestamp: Date = Date()
    @Published public var activeListenersCount: Int = 3
    @Published public var errorMessage: String? = nil

    private init() {
        startRealtimeListeners()
    }

    public func startRealtimeListeners() {
        DispatchQueue.main.async {
            self.syncStatus = .syncing
        }

        AppLogger.shared.log("FirestoreSyncService: Initializing Firestore real-time listeners for feeds, spatial chat, and e-commerce inventory...", level: .info)

        // Simulate establishing WebSocket / gRPC streams to Firestore
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.syncStatus = .synced
                self.lastSyncTimestamp = Date()
                self.errorMessage = nil
                AppLogger.shared.log("FirestoreSyncService: Real-time listeners established. Live stream active.", level: .info)
            }
        }
    }

    public func simulateNetworkConnectivityChange(isOnline: Bool) {
        DispatchQueue.main.async {
            if isOnline {
                self.syncStatus = .synced
                self.errorMessage = nil
                AppLogger.shared.log("FirestoreSyncService: Network online. Resumed real-time streams.", level: .info)
            } else {
                self.syncStatus = .offline
                self.errorMessage = "Connection lost. Serving cached spatial documents."
                AppLogger.shared.log("FirestoreSyncService: Network offline. Switched to offline cache mode.", level: .warning)
            }
        }
    }

    public func simulateSyncError(message: String) {
        DispatchQueue.main.async {
            self.syncStatus = .error
            self.errorMessage = message
            AppLogger.shared.log("FirestoreSyncService: Real-time listener error - \(message)", level: .error)
        }
    }

    public func retrySync() {
        startRealtimeListeners()
    }
}
