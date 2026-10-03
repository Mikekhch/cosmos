//
//  SecurityDashboardViewModel.swift
//  CosmosApp
//
//  ViewModel for 4-Layer Security Shield Dashboard
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

    private var cancellables = Set<AnyCancellable>()

    public init() {
        refreshAllSecurityLayers()
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
}
