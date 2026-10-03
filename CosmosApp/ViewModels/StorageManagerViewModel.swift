//
//  StorageManagerViewModel.swift
//  CosmosApp
//
//  ViewModel for Smart Cache Management & On-Demand Module Memory Optimization
//

import Foundation
import Combine

public class StorageManagerViewModel: ObservableObject {
    @Published public var currentCacheSizeBytes: Int64 = 0
    @Published public var cachedItems: [MediaCacheItem] = []
    @Published public var onDemandFeatures: [String: DynamicFeature] = [:]
    @Published public var offloadJobs: [MediaProcessingJob] = []
    @Published public var simulatedFileSizeMB: Double = 85.0

    private var cancellables = Set<AnyCancellable>()

    public init() {
        bindServices()
    }

    private func bindServices() {
        CacheManager.shared.$currentCacheSizeBytes
            .assign(to: &$currentCacheSizeBytes)

        CacheManager.shared.$cachedItems
            .assign(to: &$cachedItems)

        OnDemandFeatureManager.shared.$features
            .assign(to: &$onDemandFeatures)

        MediaOffloadService.shared.$activeJobs
            .assign(to: &$offloadJobs)
    }

    public func simulateAddCacheMediaItem() {
        let sizeInBytes = Int64(simulatedFileSizeMB * 1024 * 1024)
        let filename = "capture_\(Int(Date().timeIntervalSince1970)).mp4"
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = docs.appendingPathComponent(filename).path

        // Write mock file
        try? "MOCK MEDIA CONTENT DATA".write(toFile: path, atomically: true, encoding: .utf8)

        let newItem = CacheManager.shared.storeMediaItem(
            filename: filename,
            localPath: path,
            sizeInBytes: sizeInBytes,
            mediaType: .video
        )

        // Submit for FFmpeg Cloud Offloading
        MediaOffloadService.shared.submitMediaForServerProcessing(
            fileName: filename,
            fileSizeBytes: sizeInBytes,
            localCacheItemId: newItem.id
        ) { _ in
            // Upload complete callback automatically purges local cache file
        }
    }

    public func purgeUploadedMedia() {
        CacheManager.shared.purgeUploadedMedia()
    }

    public func purgeAllCache() {
        CacheManager.shared.purgeAllCache()
    }

    public func downloadFeatureModule(id: String) {
        OnDemandFeatureManager.shared.requestFeatureDownload(featureId: id)
    }

    public func unloadFeatureMemory(id: String) {
        OnDemandFeatureManager.shared.unloadFeatureFromMemory(featureId: id)
    }
}
