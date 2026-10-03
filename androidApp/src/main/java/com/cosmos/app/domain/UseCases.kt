package com.cosmos.app.domain

import com.cosmos.app.data.Message
import com.cosmos.app.data.Repository
import com.cosmos.app.security.AnomalyDetectionEngine

class SpatialAudioUseCase {
    fun calculateSpatialGain(x: Float, y: Float, z: Float): Float {
        val distance = Math.sqrt((x * x + y * y + z * z).toDouble()).toFloat()
        return (1.0f / (1.0f + distance)).coerceIn(0.0f, 1.0f)
    }
}

class SecurityAuditUseCase(
    private val repository: Repository,
    private val anomalyDetectionEngine: AnomalyDetectionEngine
) {
    fun processMessageSend(message: Message) {
        val threat = anomalyDetectionEngine.recordAndAnalyzeMessageSend()
        if (threat != null) {
            repository.addSecurityEvent(threat)
        }
        repository.addMessage(message)
    }
}
