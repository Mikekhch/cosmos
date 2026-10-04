package com.cosmos.app.config

import com.cosmos.app.data.RemoteConfigState
import com.cosmos.app.sync.FirebaseRealtimeDatabaseEngine
import kotlinx.coroutines.flow.StateFlow

class RemoteConfigManager(
    private val realtimeEngine: FirebaseRealtimeDatabaseEngine = FirebaseRealtimeDatabaseEngine.getInstance()
) {
    val configState: StateFlow<RemoteConfigState> = realtimeEngine.remoteConfig

    fun updateFlag(key: String, value: Boolean) {
        realtimeEngine.publishRemoteConfigFlag(key, value)
    }

    fun triggerMasterKeyRotation() {
        val newEpoch = (System.currentTimeMillis() / 1000).toInt()
        realtimeEngine.publishRemoteConfigFlag("lastMasterKeyRotationEpoch", true)
    }

    fun moderateUserOrIP(targetId: String, action: String) {
        realtimeEngine.publishRemoteConfigFlag("moderated_$targetId", action == "BAN" || action == "LOCK_IP")
    }
}
