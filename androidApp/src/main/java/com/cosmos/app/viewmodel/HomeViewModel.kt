package com.cosmos.app.viewmodel

import androidx.lifecycle.ViewModel
import com.cosmos.app.config.RemoteConfigManager
import com.cosmos.app.data.Message
import com.cosmos.app.data.Repository
import com.cosmos.app.sync.FirestoreSyncEngine
import kotlinx.coroutines.flow.StateFlow

class HomeViewModel(
    private val repository: Repository = Repository(),
    val syncEngine: FirestoreSyncEngine = FirestoreSyncEngine(),
    val remoteConfigManager: RemoteConfigManager = RemoteConfigManager()
) : ViewModel() {

    val messages: StateFlow<List<Message>> = repository.messages

    init {
        syncEngine.startRealtimeListeners()
    }

    fun sendMessage(text: String) {
        val newMsg = Message(
            id = System.currentTimeMillis().toString(),
            senderId = "User_Node_Alpha",
            text = text,
            timestamp = System.currentTimeMillis()
        )
        repository.addMessage(newMsg)
    }
}
