package com.cosmos.app.viewmodel

import androidx.lifecycle.ViewModel
import com.cosmos.app.domain.SpatialAudioUseCase
import com.cosmos.app.sync.FirebaseRealtimeDatabaseEngine
import kotlinx.coroutines.flow.StateFlow

data class SpatialNode(
    val id: String,
    val name: String,
    val x: Float,
    val y: Float,
    val z: Float,
    val gain: Float
)

class SpatialChatViewModel(
    private val realtimeEngine: FirebaseRealtimeDatabaseEngine = FirebaseRealtimeDatabaseEngine.getInstance()
) : ViewModel() {
    private val spatialAudioUseCase = SpatialAudioUseCase()

    val nodes: StateFlow<List<SpatialNode>> = realtimeEngine.spatialNodes

    init {
        // Ensure initial nodes are populated on Realtime Database if empty
        if (nodes.value.isEmpty()) {
            val initialNodes = listOf(
                SpatialNode("1", "Node Alpha", 1.2f, 0.5f, -2.0f, spatialAudioUseCase.calculateSpatialGain(1.2f, 0.5f, -2.0f)),
                SpatialNode("2", "Node Beta", -0.8f, 1.0f, -1.5f, spatialAudioUseCase.calculateSpatialGain(-0.8f, 1.0f, -1.5f)),
                SpatialNode("3", "Node Sovereign", 0.0f, 0.0f, 0.0f, spatialAudioUseCase.calculateSpatialGain(0.0f, 0.0f, 0.0f))
            )
            initialNodes.forEach { realtimeEngine.publishSpatialNodeUpdate(it) }
        }
    }

    fun updateNodePosition(id: String, x: Float, y: Float, z: Float) {
        val currentNodes = nodes.value
        val existing = currentNodes.find { it.id == id }
        val name = existing?.name ?: "Spatial Node $id"
        val gain = spatialAudioUseCase.calculateSpatialGain(x, y, z)
        val updatedNode = SpatialNode(id, name, x, y, z, gain)
        realtimeEngine.publishSpatialNodeUpdate(updatedNode)
    }

    fun addSpatialNode(name: String, x: Float, y: Float, z: Float) {
        val id = "node_${System.currentTimeMillis()}"
        val gain = spatialAudioUseCase.calculateSpatialGain(x, y, z)
        val newNode = SpatialNode(id, name, x, y, z, gain)
        realtimeEngine.publishSpatialNodeUpdate(newNode)
    }
}
