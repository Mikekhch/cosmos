//
//  CreatorStudioViewModel.swift
//  CosmosApp
//
//  ViewModel for On-Demand Creator Studio Module
//

import Foundation
import Combine

public class CreatorStudioViewModel: ObservableObject {
    @Published public var isModuleMounted: Bool = false
    @Published public var downloadProgress: Double = 0.0
    @Published public var isRecording: Bool = false
    @Published public var activeFilter: String = "Cyberpunk Obsidian"

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
}
