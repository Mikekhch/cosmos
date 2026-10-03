//
//  CreatorStudioViewModel.swift
//  CosmosApp
//
//  ViewModel for On-Demand Creator Studio & Marketplace Module
//

import Foundation
import Combine
import SwiftUI

public struct InventoryItem: Identifiable {
    public let id: String
    public let title: String
    public let sku: String
    public let stockCount: Int
    public let priceUSD: Double
    public let priceL2E: Double
    public var isTagged: Bool
    public var tagTimestampSeconds: Double?
}

public class CreatorStudioViewModel: ObservableObject {
    @Published public var isModuleMounted: Bool = false
    @Published public var downloadProgress: Double = 0.0
    @Published public var isRecording: Bool = false
    @Published public var activeFilter: String = "Cyberpunk Obsidian"

    // Viewport & Studio Settings
    @Published public var selectedAspectRatio: String = "9:16"
    @Published public var isGridOverlayActive: Bool = true
    @Published public var isSafeZoneActive: Bool = false
    @Published public var currentTimecode: Double = 14.21
    @Published public var totalTimecode: Double = 45.00
    @Published public var isPlaying: Bool = false

    // AI Neural Tools Deck
    @Published public var isAutoCaptionsEnabled: Bool = true
    @Published public var isBGMatteNeuralEnabled: Bool = true
    @Published public var isSpatialVoice3DEnabled: Bool = true

    // Multi-Warehouse Inventory & Tagging
    @Published public var selectedWarehouse: String = "Tokyo Mega-Hub (WH-01)"
    @Published public var searchQuery: String = ""
    @Published public var inventoryItems: [InventoryItem] = [
        InventoryItem(id: "1", title: "Aura Cyber-Knit Bodysuit", sku: "#CYB-2049", stockCount: 142, priceUSD: 180.00, priceL2E: 95, isTagged: true, tagTimestampSeconds: 14.21),
        InventoryItem(id: "2", title: "Holo-Visor MK-IV", sku: "#HVR-908", stockCount: 38, priceUSD: 320.00, priceL2E: 170, isTagged: false, tagTimestampSeconds: nil),
        InventoryItem(id: "3", title: "Sonic Spatial Ear-Nodes", sku: "#EAR-012", stockCount: 410, priceUSD: 85.00, priceL2E: 42, isTagged: false, tagTimestampSeconds: nil)
    ]

    public init() {
        checkModuleStatus()
    }

    public func checkModuleStatus() {
        if let feature = OnDemandFeatureManager.shared.features["creator_studio"] {
            self.isModuleMounted = feature.state == .installed
        }
    }

    public func mountModule() {
        OnDemandFeatureManager.shared.requestFeatureDownload(featureId: "creator_studio")
        checkModuleStatus()
    }

    public func captureVideoFrame() {
        // Triggers server-side FFmpeg processing offload
        MediaOffloadService.shared.submitMediaForServerProcessing(
            fileName: "creator_frame_\(Int(Date().timeIntervalSince1970)).mp4",
            fileSizeBytes: 42 * 1024 * 1024
        ) { _ in }
    }

    public func togglePlayPause() {
        isPlaying.toggle()
    }

    public func tagItemToVideo(id: String) {
        if let idx = inventoryItems.firstIndex(where: { $0.id == id }) {
            inventoryItems[idx].isTagged = true
            inventoryItems[idx].tagTimestampSeconds = currentTimecode
        }
    }

    public func exportVideo() {
        captureVideoFrame()
    }
}
