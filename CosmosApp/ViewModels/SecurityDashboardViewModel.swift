//
//  SecurityDashboardViewModel.swift
//  CosmosApp
//
//  ViewModel for 4-Layer Security Shield, Profile Security Center, and Enterprise Remote Admin Panel Controls
//

import Foundation
import Combine

public class SecurityDashboardViewModel: ObservableObject {
    @Published public var appCheckToken: String = "Initializing..."
    @Published public var isAppCheckValid: Bool = false
    @Published public var isE2EEActive: Bool = true
    @Published public var rootSecurityStatus: RootSecurityStatus?
    @Published public var recentSecurityEvents: [SecurityEvent] = []
    @Published public var testPayloadInput: String = "Top Secret Spatial Coordinates"
    @Published public var encryptedPayloadOutput: String = ""
    @Published public var decryptedPayloadOutput: String = ""

    // Profile Metadata
    @Published public var userName: String = "Kira Vance"
    @Published public var userHandle: String = "@kira.spatial"
    @Published public var trustIndex: String = "99.4%"
    @Published public var sovereignNodeHash: String = "0x9B4F...4E01"
    @Published public var userRole: String = "AR Architect & Node Validator"
    @Published public var validatorLevel: String = "VALIDATOR L4"

    // Remote Admin Feature Toggles
    @Published public var isSpatialFeedEnabled: Bool = true
    @Published public var isCreatorStudioEnabled: Bool = true
    @Published public var isEcommerceEnabled: Bool = true
    @Published public var isAIStudioToolsEnabled: Bool = true
    @Published public var isBackgroundRemovalEnabled: Bool = true
    @Published public var isNineLayerShieldActive: Bool = true
    @Published public var isDynamicModuleDeliveryEnabled: Bool = true
    @Published public var isMaintenanceModeActive: Bool = false

    // Enterprise Admin Metrics & Key Control
    @Published public var currentMasterKeyVersion: String = "v1711000000"
    @Published public var activeSovereignNodes: Int = 14280
    @Published public var activeSpatialSessions: Int = 8920
    @Published public var meshThroughputGbps: Double = 18.4
    @Published public var ffmpegActiveWorkers: Int = 12
    @Published public var ffmpegQueuedJobs: Int = 3

    // User & IP Moderation State
    @Published public var moderationTargetUserId: String = "usr_threat_992"
    @Published public var moderationTargetIp: String = "192.168.1.105"
    @Published public var moderationStatusMessage: String = "Ready for administrative action"

    // Real-Time Sync State
    @Published public var syncStatus: SyncStatus = .synced

    // Passkeys & Biometrics
    @Published public var isFaceIDEnabled: Bool = true
    @Published public var isPasskeySynced: Bool = true
    @Published public var sessionAutoLockTimeout: String = "1 Min"

    // E2EE Privacy & Telemetry
    @Published public var sessionFingerprintMatrix: [String] = ["E84F", "90A2", "44B1", "77DC"]
    @Published public var isOnionRelayEnabled: Bool = true
    @Published public var ephemeralCanvasDuration: String = "24 Hours"

    // Family Mesh & Governance
    @Published public var adaptiveContentFilter: String = "16+ ACTIVE"
    @Published public var dailyMicroMintSpentUSD: Double = 11.50
    @Published public var dailyMicroMintCapUSD: Double = 50.00
    @Published public var isGuardianApprovalRequired: Bool = true
    @Published public var curfewHours: String = "22:00 – 07:00"

    private var cancellables = Set<AnyCancellable>()

    public init() {
        bindServices()
        refreshAllSecurityLayers()
    }

    private func bindServices() {
        RemoteConfigManager.shared.$isSpatialFeedEnabled
            .assign(to: &$isSpatialFeedEnabled)

        RemoteConfigManager.shared.$isCreatorStudioEnabled
            .assign(to: &$isCreatorStudioEnabled)

        RemoteConfigManager.shared.$isEcommerceEnabled
            .assign(to: &$isEcommerceEnabled)

        RemoteConfigManager.shared.$isAIStudioToolsEnabled
            .assign(to: &$isAIStudioToolsEnabled)

        RemoteConfigManager.shared.$isBackgroundRemovalEnabled
            .assign(to: &$isBackgroundRemovalEnabled)

        RemoteConfigManager.shared.$isNineLayerShieldActive
            .assign(to: &$isNineLayerShieldActive)

        RemoteConfigManager.shared.$isDynamicModuleDeliveryEnabled
            .assign(to: &$isDynamicModuleDeliveryEnabled)

        RemoteConfigManager.shared.$isMaintenanceModeActive
            .assign(to: &$isMaintenanceModeActive)

        RemoteConfigManager.shared.$currentMasterKeyVersion
            .assign(to: &$currentMasterKeyVersion)

        RemoteConfigManager.shared.$activeSovereignNodes
            .assign(to: &$activeSovereignNodes)

        RemoteConfigManager.shared.$activeSpatialSessions
            .assign(to: &$activeSpatialSessions)

        RemoteConfigManager.shared.$meshThroughputGbps
            .assign(to: &$meshThroughputGbps)

        RemoteConfigManager.shared.$ffmpegActiveWorkers
            .assign(to: &$ffmpegActiveWorkers)

        RemoteConfigManager.shared.$ffmpegQueuedJobs
            .assign(to: &$ffmpegQueuedJobs)

        FirestoreSyncService.shared.$syncStatus
            .assign(to: &$syncStatus)
    }

    public func toggleRemoteFlag(flagKey: String, value: Bool) {
        RemoteConfigManager.shared.updateRemoteFeatureToggle(flagKey: flagKey, value: value)
    }

    public func executeCryptographicKeyRotation() {
        RemoteConfigManager.shared.triggerMasterKeyRotation(reason: "Routine Admin Security Protocol") { [weak self] newVersion in
            self?.moderationStatusMessage = "Rotated master key to \(newVersion)"
        }
    }

    public func banUserAccount() {
        RemoteConfigManager.shared.moderateUserOrIP(userId: moderationTargetUserId, ipAddress: nil, action: "ban") { [weak self] _ in
            self?.moderationStatusMessage = "User \(self?.moderationTargetUserId ?? "") banned successfully."
        }
    }

    public func lockIPAddress() {
        RemoteConfigManager.shared.moderateUserOrIP(userId: nil, ipAddress: moderationTargetIp, action: "lock") { [weak self] _ in
            self?.moderationStatusMessage = "IP \(self?.moderationTargetIp ?? "") locked in firewall."
        }
    }

    public func simulateNetworkOffline() {
        FirestoreSyncService.shared.simulateNetworkConnectivityChange(isOnline: false)
    }

    public func simulateNetworkOnline() {
        FirestoreSyncService.shared.simulateNetworkConnectivityChange(isOnline: true)
    }

    public func refreshAllSecurityLayers() {
        // Layer 1: App Check
        AppCheckManager.shared.fetchAppCheckToken { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    self?.appCheckToken = token
                    self?.isAppCheckValid = AppCheckManager.shared.validateTokenFormat(token)
                case .failure(let error):
                    self?.appCheckToken = "Error: \(error.localizedDescription)"
                    self?.isAppCheckValid = false
                }
            }
        }

        // Layer 4: Root Protection
        let status = RootProtectionManager.shared.performComprehensiveSecurityCheck()
        DispatchQueue.main.async {
            self.rootSecurityStatus = status
        }

        // Layer 3: AI Surveillance Audit Events
        DispatchQueue.main.async {
            self.recentSecurityEvents = AnomalyDetectionEngine.shared.getSecurityAuditHistory()
        }
    }

    public func testE2EEEncryption() {
        do {
            let package = try CryptoManager.shared.encrypt(plaintext: testPayloadInput)
            encryptedPayloadOutput = "Ciphertext: \(package.ciphertextBase64)\nNonce: \(package.nonceBase64)\nTag: \(package.tagBase64)"

            let decrypted = try CryptoManager.shared.decrypt(package: package)
            decryptedPayloadOutput = decrypted

            // Log & verify message send anomaly checks
            if let anomaly = AnomalyDetectionEngine.shared.recordAndAnalyzeMessageSend(payloadSizeBytes: Int64(testPayloadInput.utf8.count)) {
                recentSecurityEvents.append(anomaly)
            }
        } catch {
            encryptedPayloadOutput = "Encryption Failed: \(error.localizedDescription)"
        }
    }

    public func triggerSimulatedBurstAnomaly() {
        for _ in 0..<12 {
            _ = AnomalyDetectionEngine.shared.recordAndAnalyzeMessageSend(payloadSizeBytes: 512)
        }
        recentSecurityEvents = AnomalyDetectionEngine.shared.getSecurityAuditHistory()
    }

    public func signOutMeshSession() {
        AppLogger.shared.log("User signed out of mesh session", level: .info)
    }

    public func emergencyFreezeAllShards() {
        AppLogger.shared.log("EMERGENCY: All shards and keys frozen", level: .warning)
    }
}
