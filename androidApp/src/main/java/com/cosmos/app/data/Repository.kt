package com.cosmos.app.data

import com.cosmos.app.sync.FirebaseRealtimeDatabaseEngine
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

class Repository(
    private val realtimeEngine: FirebaseRealtimeDatabaseEngine = FirebaseRealtimeDatabaseEngine.getInstance()
) {
    val messages: StateFlow<List<Message>> = realtimeEngine.messages

    private val _securityEvents = MutableStateFlow<List<SecurityEvent>>(emptyList())
    val securityEvents: StateFlow<List<SecurityEvent>> = _securityEvents.asStateFlow()

    fun addMessage(message: Message) {
        realtimeEngine.publishMessage(message)
    }

    fun addSecurityEvent(event: SecurityEvent) {
        _securityEvents.value = listOf(event) + _securityEvents.value
    }
}
