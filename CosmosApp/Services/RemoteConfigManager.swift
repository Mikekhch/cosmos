//
//  RemoteConfigManager.swift
//  CosmosApp
//
//  Firebase Remote Config & Enterprise Admin Interface Manager
//  Controls dynamic feature toggles and UI layers without requiring app updates.
//

import Foundation
import Combine

public class RemoteConfigManager: ObservableObject {
    public static let shared = RemoteConfigManager()

    // Remote Feature Flags
    @Published public var isSpatialFeedEnabled: Bool = true
    @Published public var isCreatorStudioEnabled: Bool = true
    @Published public var isEcommerceEnabled: Bool = true
    @Published public var isAIStudioToolsEnabled: Bool = true
    @Published public var isBackgroundRemovalEnabled: Bool = true
    @Published public var isE2EESpatialChatEnabled: Bool = true

    // Remote Admin Controls
    @Published public var minimumSupportedAppVersion: String = "1.0.0"
    @Published public var isMaintenanceModeActive: Bool = false
    @Published public var maintenanceMessage: String = "Cosmos Spatial Network is under scheduled maintenance. Real-time sync resumed shortly."
    @Published public var maxUploadSizeBytes: Int64 = 100 * 1024 * 1024 // 100 MB limit
    @Published public var lastFetchedTimestamp: Date = Date()

    private init() {
        fetchRemoteConfig()
    }

    /// Simulates fetching remote configuration from Firebase Remote Config & Cloud Endpoints
    public func fetchRemoteConfig(completion: ((Bool) -> Void)? = nil) {
        AppLogger.shared.log("RemoteConfigManager: Fetching latest Firebase Remote Config parameters...", level: .info)

        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.lastFetchedTimestamp = Date()
                AppLogger.shared.log("RemoteConfigManager: Remote parameters updated successfully.", level: .info)
                completion?(true)
            }
        }
    }

    /// Remote Admin Interface: Toggles dynamic module status on the fly
    public func updateRemoteFeatureToggle(flagKey: String, value: Bool) {
        DispatchQueue.main.async {
            switch flagKey {
            case "isSpatialFeedEnabled":
                self.isSpatialFeedEnabled = value
            case "isCreatorStudioEnabled":
                self.isCreatorStudioEnabled = value
            case "isEcommerceEnabled":
                self.isEcommerceEnabled = value
            case "isAIStudioToolsEnabled":
                self.isAIStudioToolsEnabled = value
            case "isBackgroundRemovalEnabled":
                self.isBackgroundRemovalEnabled = value
            case "isE2EESpatialChatEnabled":
                self.isE2EESpatialChatEnabled = value
            case "isMaintenanceModeActive":
                self.isMaintenanceModeActive = value
            default:
                break
            }

            AppLogger.shared.log("RemoteConfigManager: Remote toggle '\(flagKey)' set to \(value)", level: .info)
        }
    }
}
