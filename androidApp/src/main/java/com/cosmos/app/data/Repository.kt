package com.cosmos.app.data

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

class Repository {
    private val _messages = MutableStateFlow<List<Message>>(emptyList())
    val messages: StateFlow<List<Message>> = _messages.asStateFlow()

    private val _securityEvents = MutableStateFlow<List<SecurityEvent>>(emptyList())
    val securityEvents: StateFlow<List<SecurityEvent>> = _securityEvents.asStateFlow()

    fun addMessage(message: Message) {
        _messages.value = _messages.value + message
    }

    fun addSecurityEvent(event: SecurityEvent) {
        _securityEvents.value = listOf(event) + _securityEvents.value
    }
}
