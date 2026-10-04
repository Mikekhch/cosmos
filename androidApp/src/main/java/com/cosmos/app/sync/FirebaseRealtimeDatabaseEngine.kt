package com.cosmos.app.sync

import com.cosmos.app.data.Message
import com.cosmos.app.data.RemoteConfigState
import com.cosmos.app.viewmodel.SpatialNode
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL

class FirebaseRealtimeDatabaseEngine private constructor(
    private val databaseUrl: String = DEFAULT_DATABASE_URL
) {
    companion object {
        const val DEFAULT_DATABASE_URL = "https://cosmos-enterprise-spatial-default-rtdb.firebaseio.com"

        @Volatile
        private var instance: FirebaseRealtimeDatabaseEngine? = null

        fun getInstance(databaseUrl: String = DEFAULT_DATABASE_URL): FirebaseRealtimeDatabaseEngine {
            return instance ?: synchronized(this) {
                instance ?: FirebaseRealtimeDatabaseEngine(databaseUrl).also { instance = it }
            }
        }
    }

    private val scope = CoroutineScope(Dispatchers.IO + SupervisorJob())

    private val _isConnected = MutableStateFlow(true)
    val isConnected: StateFlow<Boolean> = _isConnected.asStateFlow()

    private val _messages = MutableStateFlow<List<Message>>(emptyList())
    val messages: StateFlow<List<Message>> = _messages.asStateFlow()

    private val _spatialNodes = MutableStateFlow<List<SpatialNode>>(emptyList())
    val spatialNodes: StateFlow<List<SpatialNode>> = _spatialNodes.asStateFlow()

    private val _remoteConfig = MutableStateFlow(RemoteConfigState())
    val remoteConfig: StateFlow<RemoteConfigState> = _remoteConfig.asStateFlow()

    private var syncJob: Job? = null

    init {
        startRealtimeSync()
    }

    fun startRealtimeSync() {
        if (syncJob?.isActive == true) return

        syncJob = scope.launch {
            _isConnected.value = true
            while (isActive) {
                try {
                    syncRemoteConfig()
                    syncMessages()
                    syncSpatialNodes()
                    _isConnected.value = true
                } catch (e: Exception) {
                    _isConnected.value = false
                }
                delay(2000) // Poll real-time database every 2s for live state synchronization
            }
        }
    }

    suspend fun syncRemoteConfig() = withContext(Dispatchers.IO) {
        val jsonString = httpGet("$databaseUrl/remote_config.json")
        if (jsonString != null && jsonString != "null" && jsonString.startsWith("{")) {
            val state = parseRemoteConfigJson(jsonString)
            _remoteConfig.value = state
        }
    }

    suspend fun syncMessages() = withContext(Dispatchers.IO) {
        val jsonString = httpGet("$databaseUrl/messages.json")
        if (jsonString != null && jsonString != "null") {
            val parsedMessages = parseMessagesJson(jsonString)
            if (parsedMessages.isNotEmpty()) {
                _messages.value = parsedMessages
            }
        }
    }

    suspend fun syncSpatialNodes() = withContext(Dispatchers.IO) {
        val jsonString = httpGet("$databaseUrl/spatial_nodes.json")
        if (jsonString != null && jsonString != "null") {
            val parsedNodes = parseSpatialNodesJson(jsonString)
            if (parsedNodes.isNotEmpty()) {
                _spatialNodes.value = parsedNodes
            }
        }
    }

    fun publishMessage(message: Message) {
        scope.launch(Dispatchers.IO) {
            val updated = _messages.value + message
            _messages.value = updated
            val json = formatMessageJson(message)
            httpPatch("$databaseUrl/messages/${message.id}.json", json)
        }
    }

    fun publishSpatialNodeUpdate(node: SpatialNode) {
        scope.launch(Dispatchers.IO) {
            val updated = _spatialNodes.value.map { if (it.id == node.id) node else it }
            _spatialNodes.value = if (_spatialNodes.value.any { it.id == node.id }) updated else _spatialNodes.value + node
            val json = formatSpatialNodeJson(node)
            httpPatch("$databaseUrl/spatial_nodes/${node.id}.json", json)
        }
    }

    fun publishRemoteConfigFlag(key: String, value: Boolean) {
        scope.launch(Dispatchers.IO) {
            val current = _remoteConfig.value
            val updated = when (key) {
                "isSpatialFeedEnabled" -> current.copy(isSpatialFeedEnabled = value)
                "isCreatorStudioEnabled" -> current.copy(isCreatorStudioEnabled = value)
                "isNineLayerShieldActive" -> current.copy(isNineLayerShieldActive = value)
                "isDynamicModuleDeliveryEnabled" -> current.copy(isDynamicModuleDeliveryEnabled = value)
                else -> current
            }
            _remoteConfig.value = updated
            httpPatch("$databaseUrl/remote_config.json", "{\"$key\": $value}")
        }
    }

    private fun httpGet(urlString: String): String? {
        return try {
            val url = URL(urlString)
            val conn = url.openConnection() as HttpURLConnection
            conn.requestMethod = "GET"
            conn.connectTimeout = 3000
            conn.readTimeout = 3000
            if (conn.responseCode == 200) {
                val reader = BufferedReader(InputStreamReader(conn.inputStream))
                val response = StringBuilder()
                var line: String?
                while (reader.readLine().also { line = it } != null) {
                    response.append(line)
                }
                reader.close()
                response.toString()
            } else {
                null
            }
        } catch (e: Exception) {
            null
        }
    }

    private fun httpPatch(urlString: String, jsonBody: String): Boolean {
        return try {
            val url = URL(urlString)
            val conn = url.openConnection() as HttpURLConnection
            conn.requestMethod = "POST" // Default to POST or use X-HTTP-Method-Override for PATCH
            conn.setRequestProperty("X-HTTP-Method-Override", "PATCH")
            conn.setRequestProperty("Content-Type", "application/json")
            conn.doOutput = true
            conn.connectTimeout = 3000
            conn.readTimeout = 3000

            val writer = OutputStreamWriter(conn.outputStream)
            writer.write(jsonBody)
            writer.flush()
            writer.close()

            val responseCode = conn.responseCode
            responseCode in 200..299
        } catch (e: Exception) {
            false
        }
    }

    private fun parseRemoteConfigJson(json: String): RemoteConfigState {
        fun extractBool(key: String, default: Boolean): Boolean {
            val pattern = "\"$key\"\\s*:\\s*(true|false)".toRegex()
            val match = pattern.find(json)
            return match?.groupValues?.get(1)?.toBoolean() ?: default
        }
        fun extractLong(key: String, default: Long): Long {
            val pattern = "\"$key\"\\s*:\\s*(\\d+)".toRegex()
            val match = pattern.find(json)
            return match?.groupValues?.get(1)?.toLong() ?: default
        }
        fun extractInt(key: String, default: Int): Int {
            val pattern = "\"$key\"\\s*:\\s*(\\d+)".toRegex()
            val match = pattern.find(json)
            return match?.groupValues?.get(1)?.toInt() ?: default
        }
        fun extractDouble(key: String, default: Double): Double {
            val pattern = "\"$key\"\\s*:\\s*([0-9.]+)".toRegex()
            val match = pattern.find(json)
            return match?.groupValues?.get(1)?.toDouble() ?: default
        }

        return RemoteConfigState(
            isSpatialFeedEnabled = extractBool("isSpatialFeedEnabled", true),
            isCreatorStudioEnabled = extractBool("isCreatorStudioEnabled", true),
            isNineLayerShieldActive = extractBool("isNineLayerShieldActive", true),
            isDynamicModuleDeliveryEnabled = extractBool("isDynamicModuleDeliveryEnabled", true),
            maxCacheLimitMB = extractLong("maxCacheLimitMB", 300),
            activeSovereignNodes = extractInt("activeSovereignNodes", 14280),
            meshThroughputGbps = extractDouble("meshThroughputGbps", 18.4),
            averageLatencyMs = extractDouble("averageLatencyMs", 14.2)
        )
    }

    private fun parseMessagesJson(json: String): List<Message> {
        val list = mutableListOf<Message>()
        val idRegex = "\"id\"\\s*:\\s*\"([^\"]+)\"".toRegex()
        val senderRegex = "\"senderId\"\\s*:\\s*\"([^\"]+)\"".toRegex()
        val textRegex = "\"text\"\\s*:\\s*\"([^\"]+)\"".toRegex()
        val tsRegex = "\"timestamp\"\\s*:\\s*(\\d+)".toRegex()

        // Match individual message objects
        val objRegex = "\\{[^{}]*\"id\"[^{}]*\\}".toRegex()
        objRegex.findAll(json).forEach { match ->
            val obj = match.value
            val id = idRegex.find(obj)?.groupValues?.get(1)
            val senderId = senderRegex.find(obj)?.groupValues?.get(1) ?: "Anonymous"
            val text = textRegex.find(obj)?.groupValues?.get(1) ?: ""
            val timestamp = tsRegex.find(obj)?.groupValues?.get(1)?.toLong() ?: System.currentTimeMillis()

            if (id != null) {
                list.add(
                    Message(
                        id = id,
                        senderId = senderId,
                        text = text,
                        timestamp = timestamp,
                        isEncrypted = true
                    )
                )
            }
        }
        return list
    }

    private fun parseSpatialNodesJson(json: String): List<SpatialNode> {
        val list = mutableListOf<SpatialNode>()
        val idRegex = "\"id\"\\s*:\\s*\"([^\"]+)\"".toRegex()
        val nameRegex = "\"name\"\\s*:\\s*\"([^\"]+)\"".toRegex()
        val xRegex = "\"x\"\\s*:\\s*([-0-9.]+)".toRegex()
        val yRegex = "\"y\"\\s*:\\s*([-0-9.]+)".toRegex()
        val zRegex = "\"z\"\\s*:\\s*([-0-9.]+)".toRegex()
        val gainRegex = "\"gain\"\\s*:\\s*([0-9.]+)".toRegex()

        val objRegex = "\\{[^{}]*\"id\"[^{}]*\\}".toRegex()
        objRegex.findAll(json).forEach { match ->
            val obj = match.value
            val id = idRegex.find(obj)?.groupValues?.get(1)
            val name = nameRegex.find(obj)?.groupValues?.get(1) ?: "Spatial Node"
            val x = xRegex.find(obj)?.groupValues?.get(1)?.toFloat() ?: 0.0f
            val y = yRegex.find(obj)?.groupValues?.get(1)?.toFloat() ?: 0.0f
            val z = zRegex.find(obj)?.groupValues?.get(1)?.toFloat() ?: 0.0f
            val gain = gainRegex.find(obj)?.groupValues?.get(1)?.toFloat() ?: 1.0f

            if (id != null) {
                list.add(
                    SpatialNode(
                        id = id,
                        name = name,
                        x = x,
                        y = y,
                        z = z,
                        gain = gain
                    )
                )
            }
        }
        return list
    }

    private fun formatMessageJson(message: Message): String {
        return """
            {
                "id": "${message.id}",
                "senderId": "${message.senderId}",
                "text": "${message.text.replace("\"", "\\\"")}",
                "timestamp": ${message.timestamp},
                "isEncrypted": ${message.isEncrypted},
                "spatialPositionX": ${message.spatialPositionX},
                "spatialPositionY": ${message.spatialPositionY},
                "spatialPositionZ": ${message.spatialPositionZ}
            }
        """.trimIndent()
    }

    private fun formatSpatialNodeJson(node: SpatialNode): String {
        return """
            {
                "id": "${node.id}",
                "name": "${node.name.replace("\"", "\\\"")}",
                "x": ${node.x},
                "y": ${node.y},
                "z": ${node.z},
                "gain": ${node.gain}
            }
        """.trimIndent()
    }
}
