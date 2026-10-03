//
//  CacheManager.swift
//  CosmosApp
//
//  Smart Cache Management Engine
//  Strict 300MB Limit & LRU Eviction & Auto-Purge Logic
//

import Foundation

public class CacheManager: ObservableObject {
    public static let shared = CacheManager()

    // Strict 300MB limit in bytes
    public let maxCacheLimitBytes: Int64 = 300 * 1024 * 1024 // 300 MB

    @Published public private(set) var currentCacheSizeBytes: Int64 = 0
    @Published public private(set) var cachedItems: [MediaCacheItem] = []

    private let queue = DispatchQueue(label: "com.cosmos.cachemanager", qos: .userInitiated)
    private let indexFileUrl: URL

    private init() {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.indexFileUrl = docs.appendingPathComponent("cosmos_cache_index.json")
        loadCacheIndex()
    }

    // MARK: - Cache Index Management

    private func loadCacheIndex() {
        queue.async { [weak self] in
            guard let self = self else { return }
            if let data = try? Data(contentsOf: self.indexFileUrl),
               let items = try? JSONDecoder().decode([MediaCacheItem].self, from: data) {
                let sortedItems = items.sorted { $0.lastAccessedDate < $1.lastAccessedDate } // LRU order
                let totalSize = sortedItems.reduce(0) { $0 + $1.sizeInBytes }

                DispatchQueue.main.async {
                    self.cachedItems = sortedItems
                    self.currentCacheSizeBytes = totalSize
                }
            }
        }
    }

    private func saveCacheIndex() {
        let itemsToSave = cachedItems
        queue.async { [weak self] in
            guard let self = self else { return }
            if let data = try? JSONEncoder().encode(itemsToSave) {
                try? data.write(to: self.indexFileUrl)
            }
        }
    }

    // MARK: - Cache Operations

    public func storeMediaItem(filename: String, localPath: String, sizeInBytes: Int64, mediaType: MediaCacheItem.MediaType) -> MediaCacheItem {
        let newItem = MediaCacheItem(
            filename: filename,
            localPath: localPath,
            sizeInBytes: sizeInBytes,
            lastAccessedDate: Date(),
            isUploadedToServer: false,
            mediaType: mediaType
        )

        DispatchQueue.main.async {
            self.cachedItems.append(newItem)
            self.currentCacheSizeBytes += sizeInBytes
            self.enforceCacheLimitIfNeeded()
            self.saveCacheIndex()
        }

        AppLogger.shared.log("CacheManager: Stored '\(filename)' (\(sizeInBytes / 1024) KB). Total cache: \(currentCacheSizeBytes / (1024 * 1024)) MB", level: .info)
        return newItem
    }

    public func accessMediaItem(id: String) {
        DispatchQueue.main.async {
            if let index = self.cachedItems.firstIndex(where: { $0.id == id }) {
                self.cachedItems[index].lastAccessedDate = Date()
                self.saveCacheIndex()
            }
        }
    }

    // MARK: - LRU Cache Eviction & 300MB Strict Enforcement

    public func enforceCacheLimitIfNeeded() {
        guard currentCacheSizeBytes > maxCacheLimitBytes else { return }

        AppLogger.shared.log("CacheManager: Quota exceeded (\(currentCacheSizeBytes / (1024 * 1024)) MB > 300 MB). Triggering LRU eviction...", level: .warning)

        // Sort by least recently used
        let sortedLRU = cachedItems.sorted { $0.lastAccessedDate < $1.lastAccessedDate }
        var bytesToRemove = currentCacheSizeBytes - maxCacheLimitBytes
        var itemsToRemoveIds: Set<String> = []

        for item in sortedLRU {
            if bytesToRemove <= 0 { break }
            itemsToRemoveIds.insert(item.id)
            bytesToRemove -= item.sizeInBytes
        }

        for item in sortedLRU where itemsToRemoveIds.contains(item.id) {
            deleteLocalCacheFile(at: item.localPath)
        }

        cachedItems.removeAll { itemsToRemoveIds.contains($0.id) }
        recalculateTotalCacheSize()
        saveCacheIndex()
    }

    // MARK: - Auto-Purge After Media Upload

    public func notifyUploadCompleted(itemId: String) {
        DispatchQueue.main.async {
            if let index = self.cachedItems.firstIndex(where: { $0.id == itemId }) {
                self.cachedItems[index].isUploadedToServer = true
                AppLogger.shared.log("CacheManager: Auto-purging local file for uploaded item '\(self.cachedItems[index].filename)'", level: .info)

                self.deleteLocalCacheFile(at: self.cachedItems[index].localPath)
                self.cachedItems.remove(at: index)
                self.recalculateTotalCacheSize()
                self.saveCacheIndex()
            }
        }
    }

    public func purgeUploadedMedia() {
        DispatchQueue.main.async {
            let uploaded = self.cachedItems.filter { $0.isUploadedToServer }
            for item in uploaded {
                self.deleteLocalCacheFile(at: item.localPath)
            }
            self.cachedItems.removeAll { $0.isUploadedToServer }
            self.recalculateTotalCacheSize()
            self.saveCacheIndex()
        }
    }

    public func purgeAllCache() {
        DispatchQueue.main.async {
            for item in self.cachedItems {
                self.deleteLocalCacheFile(at: item.localPath)
            }
            self.cachedItems.removeAll()
            self.currentCacheSizeBytes = 0
            self.saveCacheIndex()
            AppLogger.shared.log("CacheManager: Purged all cache items", level: .info)
        }
    }

    private func deleteLocalCacheFile(at path: String) {
        try? FileManager.default.removeItem(atPath: path)
    }

    private func recalculateTotalCacheSize() {
        currentCacheSizeBytes = cachedItems.reduce(0) { $0 + $1.sizeInBytes }
    }
}
