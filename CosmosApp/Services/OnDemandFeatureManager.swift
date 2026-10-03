//
//  OnDemandFeatureManager.swift
//  CosmosApp
//
//  Dynamic Feature Modules Engine (On-Demand Feature Delivery & Memory Unloading)
//

import Foundation
import Combine

public class OnDemandFeatureManager: ObservableObject {
    public static let shared = OnDemandFeatureManager()

    @Published public var features: [String: DynamicFeature] = [:]

    private init() {
        setupInitialFeatures()
    }

    private func setupInitialFeatures() {
        let creatorStudio = DynamicFeature(
            id: "creator_studio",
            moduleName: "CreatorStudioModule",
            displayName: "Creator Studio (AR & Video Frame Capture)",
            downloadSizeMB: 45.0,
            state: .notDownloaded
        )

        let avatar3D = DynamicFeature(
            id: "avatar_3d",
            moduleName: "Avatar3DModule",
            displayName: "3D Holographic Avatars & Spatial Mesh",
            downloadSizeMB: 65.0,
            state: .notDownloaded
        )

        features["creator_studio"] = creatorStudio
        features["avatar_3d"] = avatar3D
    }

    // MARK: - On-Demand Module Loading

    public func requestFeatureDownload(featureId: String) {
        guard var feature = features[featureId], feature.state != .installed else { return }

        feature.state = .downloading(progress: 0.1)
        features[featureId] = feature
        AppLogger.shared.log("OnDemandFeatureManager: Requesting dynamic download for module '\(feature.moduleName)' (\(feature.downloadSizeMB) MB)", level: .info)

        // Simulate progressive dynamic asset bundle downloading
        var currentProgress = 0.1
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            currentProgress += 0.25
            if currentProgress >= 1.0 {
                timer.invalidate()
                DispatchQueue.main.async {
                    var updated = self.features[featureId]
                    updated?.state = .installed
                    updated?.isLoadedInMemory = true
                    updated?.memoryUsageMB = featureId == "creator_studio" ? 32.5 : 48.0
                    self.features[featureId] = updated
                    AppLogger.shared.log("OnDemandFeatureManager: Module '\(feature.moduleName)' downloaded and mounted dynamically.", level: .info)
                }
            } else {
                DispatchQueue.main.async {
                    var updated = self.features[featureId]
                    updated?.state = .downloading(progress: min(currentProgress, 0.99))
                    self.features[featureId] = updated
                }
            }
        }
    }

    // MARK: - Memory Lifecycle Optimization

    public func unloadFeatureFromMemory(featureId: String) {
        guard var feature = features[featureId], feature.isLoadedInMemory else { return }
        feature.isLoadedInMemory = false
        feature.memoryUsageMB = 0.0
        features[featureId] = feature

        // Trigger ARC cleanup / system garbage collection hint
        AppLogger.shared.log("OnDemandFeatureManager: Unloaded module '\(feature.moduleName)' assets from active memory. Freed \(featureId == "creator_studio" ? "32.5" : "48.0") MB RAM", level: .info)
    }
}
