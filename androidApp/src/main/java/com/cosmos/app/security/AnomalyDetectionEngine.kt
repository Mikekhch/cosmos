package com.cosmos.app.security

import com.cosmos.app.data.SecurityEvent

class AnomalyDetectionEngine {
    private val messageTimestamps = mutableListOf<Long>()
    private var lastLatitude: Double = 37.7749
    private var lastLongitude: Double = -122.4194
    private var lastLocationTime: Long = System.currentTimeMillis()

    fun recordAndAnalyzeMessageSend(): SecurityEvent? {
        val now = System.currentTimeMillis()
        messageTimestamps.add(now)
        messageTimestamps.removeAll { now - it > 5000 }

        if (messageTimestamps.size > 10) {
            return SecurityEvent(
                id = "anom-" + System.currentTimeMillis(),
                type = "BURST_VELOCITY_THREAT",
                severity = "HIGH",
                details = "Burst message limit exceeded: ${messageTimestamps.size} messages in 5 seconds",
                timestamp = now
            )
        }
        return null
    }

    fun analyzeGeolocationJump(newLat: Double, newLng: Double): SecurityEvent? {
        val now = System.currentTimeMillis()
        val timeDiffHours = (now - lastLocationTime) / (1000.0 * 3600.0)

        // Approximate distance check in km
        val distKm = Math.sqrt(Math.pow((newLat - lastLatitude) * 111.0, 2.0) + Math.pow((newLng - lastLongitude) * 111.0, 2.0))

        lastLatitude = newLat
        lastLongitude = newLng
        lastLocationTime = now

        if (timeDiffHours > 0 && (distKm / timeDiffHours) > 1000.0) { // Speed > 1000 km/h
            return SecurityEvent(
                id = "geo-" + System.currentTimeMillis(),
                type = "IMPOSSIBLE_GEOLOCATION_JUMP",
                severity = "CRITICAL",
                details = "Impossible movement detected: ${distKm.toInt()} km in ${String.format("%.2f", timeDiffHours)} hours",
                timestamp = now
            )
        }
        return null
    }
}
