package com.cosmos.app.sync

import com.cosmos.app.data.Message
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

enum class SyncStatus {
    CONNECTED, CONNECTING, OFFLINE
}

class FirestoreSyncEngine(
    val realtimeDatabaseEngine: FirebaseRealtimeDatabaseEngine = FirebaseRealtimeDatabaseEngine.getInstance()
) {
    private val _syncStatus = MutableStateFlow(SyncStatus.CONNECTED)
    val syncStatus: StateFlow<SyncStatus> = _syncStatus.asStateFlow()

    val incomingMessages: StateFlow<List<Message>> = realtimeDatabaseEngine.messages

    fun startRealtimeListeners() {
        _syncStatus.value = SyncStatus.CONNECTED
        realtimeDatabaseEngine.startRealtimeSync()
    }

    fun simulateNetworkConnectivityChange(isConnected: Boolean) {
        _syncStatus.value = if (isConnected) SyncStatus.CONNECTED else SyncStatus.OFFLINE
    }
}
