package com.cosmos.app.ui

import androidx.compose.animation.*
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.cosmos.app.viewmodel.HomeViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(viewModel: HomeViewModel = HomeViewModel()) {
    val messages by viewModel.messages.collectAsState()
    val configState by viewModel.remoteConfigManager.configState.collectAsState()
    var newMessageText by remember { mutableStateOf("") }
    var activeFilter by remember { mutableStateOf("All Mesh") }

    // Colors according to Obsidian Glass specification
    val bgCanvas = Color(0xFF0F131C)
    val glassContainer = Color(0xBF181C24)
    val glassCard = Color(0x991C2028)
    val cyanAccent = Color(0xFF00F0FF)
    val indigoAccent = Color(0xFF6366F1)
    val emeraldAccent = Color(0xFF10B981)
    val glassBorder = Color(0x33FFFFFF)
    val textPrimary = Color(0xFFDFE2EE)
    val textMuted = Color(0xFFB9CACB)

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(
                brush = Brush.verticalGradient(
                    colors = listOf(
                        Color(0xFF0B0F17),
                        bgCanvas,
                        Color(0xFF141A29)
                    )
                )
            )
            .padding(16.dp)
    ) {
        // --- Header Banner ---
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Box(
                        modifier = Modifier
                            .size(10.dp)
                            .clip(CircleShape)
                            .background(emeraldAccent)
                            .shadow(8.dp, CircleShape, spotColor = emeraldAccent)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = "COSMOS // MESH",
                        color = cyanAccent,
                        fontSize = 22.sp,
                        fontWeight = FontWeight.Bold,
                        letterSpacing = (-0.5).sp
                    )
                }
                Text(
                    text = "Sovereign AR Communications Network",
                    color = textMuted,
                    fontSize = 11.sp
                )
            }

            // Live Network Status Badge
            Surface(
                shape = RoundedCornerShape(9999.dp),
                color = Color(0x1F10B981),
                border = BorderStroke(1.dp, Color(0x4D10B981))
            ) {
                Row(
                    modifier = Modifier.padding(horizontal = 10.dp, vertical = 6.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "LIVE MESH",
                        color = emeraldAccent,
                        fontSize = 10.sp,
                        fontWeight = FontWeight.Bold,
                        letterSpacing = 1.sp
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(12.dp))

        // --- System Telemetry Glass Panel ---
        Card(
            shape = RoundedCornerShape(24.dp),
            colors = CardDefaults.cardColors(containerColor = glassContainer),
            border = BorderStroke(1.dp, glassBorder),
            modifier = Modifier
                .fillMaxWidth()
                .shadow(16.dp, RoundedCornerShape(24.dp), spotColor = cyanAccent)
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "SYSTEM TELEMETRY",
                        color = textPrimary,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Bold,
                        letterSpacing = 0.5.sp
                    )
                    Text(
                        text = "RTDB ONLINE",
                        color = cyanAccent,
                        fontSize = 10.sp,
                        fontFamily = FontFamily.Monospace,
                        fontWeight = FontWeight.SemiBold
                    )
                }

                Spacer(modifier = Modifier.height(12.dp))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    TelemetryMetricItem(
                        label = "Sovereign Nodes",
                        value = "${configState.activeSovereignNodes}",
                        accentColor = cyanAccent
                    )
                    TelemetryMetricItem(
                        label = "Latency",
                        value = "${configState.averageLatencyMs}ms",
                        accentColor = emeraldAccent
                    )
                    TelemetryMetricItem(
                        label = "Throughput",
                        value = "18.4 Gbps",
                        accentColor = indigoAccent
                    )
                    TelemetryMetricItem(
                        label = "Cache Limit",
                        value = "<300MB",
                        accentColor = Color(0xFFFFB4AB)
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // --- Stream Filters & Input ---
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = "Spatial Feed Stream",
                color = textPrimary,
                fontSize = 18.sp,
                fontWeight = FontWeight.Bold
            )

            Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                listOf("All Mesh", "Encrypted", "Spatial").forEach { filter ->
                    val isSelected = activeFilter == filter
                    Box(
                        modifier = Modifier
                            .clip(RoundedCornerShape(9999.dp))
                            .background(if (isSelected) cyanAccent else Color(0x1AFFFFFF))
                            .clickable { activeFilter = filter }
                            .padding(horizontal = 10.dp, vertical = 4.dp)
                    ) {
                        Text(
                            text = filter,
                            color = if (isSelected) Color.Black else textMuted,
                            fontSize = 10.sp,
                            fontWeight = FontWeight.SemiBold
                        )
                    }
                }
            }
        }

        Spacer(modifier = Modifier.height(10.dp))

        // Recessed Glass Input Field
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            TextField(
                value = newMessageText,
                onValueChange = { newMessageText = it },
                placeholder = {
                    Text(
                        "Broadcast encrypted mesh packet...",
                        color = textMuted,
                        fontSize = 12.sp
                    )
                },
                colors = TextFieldDefaults.colors(
                    focusedContainerColor = Color(0x33000000),
                    unfocusedContainerColor = Color(0x22000000),
                    focusedIndicatorColor = cyanAccent,
                    unfocusedIndicatorColor = Color.Transparent,
                    focusedTextColor = textPrimary,
                    unfocusedTextColor = textPrimary
                ),
                shape = RoundedCornerShape(16.dp),
                modifier = Modifier
                    .weight(1f)
                    .border(1.dp, glassBorder, RoundedCornerShape(16.dp))
            )

            Spacer(modifier = Modifier.width(8.dp))

            Button(
                onClick = {
                    if (newMessageText.isNotBlank()) {
                        viewModel.publishMessage("User_Node_77", newMessageText)
                        newMessageText = ""
                    }
                },
                colors = ButtonDefaults.buttonColors(containerColor = cyanAccent),
                shape = RoundedCornerShape(16.dp),
                modifier = Modifier
                    .height(52.dp)
                    .shadow(8.dp, RoundedCornerShape(16.dp), spotColor = cyanAccent)
            ) {
                Text(
                    text = "Send",
                    color = Color.Black,
                    fontWeight = FontWeight.Bold,
                    fontSize = 13.sp
                )
            }
        }

        Spacer(modifier = Modifier.height(14.dp))

        // --- Feed Stream Items ---
        LazyColumn(
            verticalArrangement = Arrangement.spacedBy(10.dp),
            modifier = Modifier.fillMaxSize()
        ) {
            items(messages) { msg ->
                Card(
                    shape = RoundedCornerShape(20.dp),
                    colors = CardDefaults.cardColors(containerColor = glassCard),
                    border = BorderStroke(1.dp, glassBorder),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Column(modifier = Modifier.padding(14.dp)) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Box(
                                    modifier = Modifier
                                        .size(32.dp)
                                        .clip(CircleShape)
                                        .background(
                                            Brush.linearGradient(
                                                colors = listOf(cyanAccent, indigoAccent)
                                            )
                                        ),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Text(
                                        text = msg.senderId.take(2).uppercase(),
                                        color = Color.Black,
                                        fontWeight = FontWeight.Bold,
                                        fontSize = 11.sp
                                    )
                                }
                                Spacer(modifier = Modifier.width(10.dp))
                                Column {
                                    Text(
                                        text = msg.senderId,
                                        color = cyanAccent,
                                        fontWeight = FontWeight.Bold,
                                        fontSize = 13.sp
                                    )
                                    Text(
                                        text = "Node #${msg.id.takeLast(4)} • Just Now",
                                        color = textMuted,
                                        fontSize = 10.sp
                                    )
                                }
                            }

                            // E2EE Verified Badge
                            Surface(
                                shape = RoundedCornerShape(9999.dp),
                                color = Color(0x1F00F0FF),
                                border = BorderStroke(1.dp, Color(0x4D00F0FF))
                            ) {
                                Text(
                                    text = "AES-256 E2EE",
                                    color = cyanAccent,
                                    fontSize = 9.sp,
                                    fontFamily = FontFamily.Monospace,
                                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp)
                                )
                            }
                        }

                        Spacer(modifier = Modifier.height(10.dp))

                        Text(
                            text = msg.text,
                            color = textPrimary,
                            fontSize = 14.sp,
                            lineHeight = 20.sp
                        )

                        Spacer(modifier = Modifier.height(12.dp))

                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                                Text(
                                    text = "⚡ Resonate",
                                    color = textMuted,
                                    fontSize = 11.sp,
                                    fontWeight = FontWeight.Medium
                                )
                                Text(
                                    text = "💬 Relay",
                                    color = textMuted,
                                    fontSize = 11.sp,
                                    fontWeight = FontWeight.Medium
                                )
                            }

                            Text(
                                text = "Join Spatial Stage →",
                                color = cyanAccent,
                                fontSize = 11.sp,
                                fontWeight = FontWeight.Bold
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun TelemetryMetricItem(label: String, value: String, accentColor: Color) {
    Column {
        Text(
            text = value,
            color = accentColor,
            fontSize = 15.sp,
            fontFamily = FontFamily.Monospace,
            fontWeight = FontWeight.Bold
        )
        Text(
            text = label,
            color = Color(0xFFB9CACB),
            fontSize = 9.sp
        )
    }
}
