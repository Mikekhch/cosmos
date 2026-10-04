package com.cosmos.app.sync

import com.cosmos.app.data.Message
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

enum class SyncStatus {
    CONNECTED, CONNECTING, OFFLINE
}

class FirestoreSyncEngine {
    private val _syncStatus = MutableStateFlow(SyncStatus.CONNECTED)
    val syncStatus: StateFlow<SyncStatus> = _syncStatus.asStateFlow()

    private val _incomingMessages = MutableStateFlow<List<Message>>(emptyList())
    val incomingMessages: StateFlow<List<Message>> = _incomingMessages.asStateFlow()

    fun startRealtimeListeners() {
        _syncStatus.value = SyncStatus.CONNECTED
    }

    fun publishMessage(message: Message) {
        _incomingMessages.value = _incomingMessages.value + message
    }

    fun simulateNetworkConnectivityChange(isConnected: Boolean) {
        _syncStatus.value = if (isConnected) SyncStatus.CONNECTED else SyncStatus.OFFLINE
    }
}
