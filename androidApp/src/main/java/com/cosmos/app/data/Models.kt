package com.cosmos.app.data

data class Message(
    val id: String,
    val senderId: String,
    val text: String,
    val timestamp: Long,
    val isEncrypted: Boolean = true,
    val spatialPositionX: Float = 0.0f,
    val spatialPositionY: Float = 0.0f,
    val spatialPositionZ: Float = 0.0f
)

data class SecurityEvent(
    val id: String,
    val type: String,
    val severity: String,
    val details: String,
    val timestamp: Long,
    val ipAddress: String = "192.168.1.1"
)

data class RemoteConfigState(
    val isSpatialFeedEnabled: Boolean = true,
    val isCreatorStudioEnabled: Boolean = true,
    val isNineLayerShieldActive: Boolean = true,
    val isDynamicModuleDeliveryEnabled: Boolean = true,
    val maxCacheLimitMB: Long = 300,
    val activeSovereignNodes: Int = 14280,
    val meshThroughputGbps: Double = 18.4,
    val averageLatencyMs: Double = 14.2
)

data class MediaCacheItem(
    val id: String,
    val fileName: String,
    val sizeInBytes: Long,
    val lastAccessedTimestamp: Long,
    val isUploaded: Boolean = false
)

data class MediaProcessingJob(
    val jobId: String,
    val status: String,
    val inputFormat: String,
    val outputFormat: String,
    val progress: Int
)
