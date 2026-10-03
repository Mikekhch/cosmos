package com.cosmos.app.cache

import com.cosmos.app.data.MediaCacheItem

class CacheManager {
    private val maxCacheSizeBytes: Long = 300 * 1024 * 1024 // Strict 300MB limit
    private val cachedItems = mutableListOf<MediaCacheItem>()

    fun getCalculatedCacheUsageBytes(): Long {
        return cachedItems.sumOf { it.sizeInBytes }
    }

    fun addCacheItem(item: MediaCacheItem) {
        cachedItems.add(item)
        enforceCacheLimitIfNeeded()
    }

    fun enforceCacheLimitIfNeeded() {
        while (getCalculatedCacheUsageBytes() > maxCacheSizeBytes && cachedItems.isNotEmpty()) {
            // Evict least recently accessed item (LRU)
            val lruItem = cachedItems.minByOrNull { it.lastAccessedTimestamp }
            if (lruItem != null) {
                cachedItems.remove(lruItem)
            } else {
                break
            }
        }
    }

    fun purgeUploadedMedia(itemId: String) {
        cachedItems.removeAll { it.id == itemId }
    }

    fun getItems(): List<MediaCacheItem> = cachedItems.toList()
}
