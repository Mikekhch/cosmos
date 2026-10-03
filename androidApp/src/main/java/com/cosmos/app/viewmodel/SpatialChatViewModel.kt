package com.cosmos.app.viewmodel

import androidx.lifecycle.ViewModel
import com.cosmos.app.domain.SpatialAudioUseCase
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

data class SpatialNode(
    val id: String,
    val name: String,
    val x: Float,
    val y: Float,
    val z: Float,
    val gain: Float
)

class SpatialChatViewModel : ViewModel() {
    private val spatialAudioUseCase = SpatialAudioUseCase()

    private val _nodes = MutableStateFlow<List<SpatialNode>>(
        listOf(
            SpatialNode("1", "Node Alpha", 1.2f, 0.5f, -2.0f, 0.35f),
            SpatialNode("2", "Node Beta", -0.8f, 1.0f, -1.5f, 0.42f),
            SpatialNode("3", "Node Sovereign", 0.0f, 0.0f, 0.0f, 1.00f)
        )
    )
    val nodes: StateFlow<List<SpatialNode>> = _nodes.asStateFlow()

    fun updateNodePosition(id: String, x: Float, y: Float, z: Float) {
        val updated = _nodes.value.map { node ->
            if (node.id == id) {
                val gain = spatialAudioUseCase.calculateSpatialGain(x, y, z)
                node.copy(x = x, y = y, z = z, gain = gain)
            } else {
                node
            }
        }
        _nodes.value = updated
    }
}
