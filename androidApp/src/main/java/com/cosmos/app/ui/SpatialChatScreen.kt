package com.cosmos.app.ui

import androidx.compose.animation.core.*
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
import com.cosmos.app.viewmodel.SpatialChatViewModel

@Composable
fun SpatialChatScreen(viewModel: SpatialChatViewModel = SpatialChatViewModel()) {
    val nodes by viewModel.nodes.collectAsState()
    var isStageMuted by remember { mutableStateOf(false) }
    var spatialGainValue by remember { mutableStateOf(0.85f) }

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
                Text(
                    text = "SPATIAL CHAT & 3D STAGE",
                    color = cyanAccent,
                    fontSize = 22.sp,
                    fontWeight = FontWeight.Bold,
                    letterSpacing = (-0.5).sp
                )
                Text(
                    text = "Real-time Positional Audio & Mesh Nodes",
                    color = textMuted,
                    fontSize = 11.sp
                )
            }

            Surface(
                shape = RoundedCornerShape(9999.dp),
                color = Color(0x1F6366F1),
                border = BorderStroke(1.dp, Color(0x4D6366F1))
            ) {
                Text(
                    text = "3D AUDIO ACTIVE",
                    color = indigoAccent,
                    fontSize = 10.sp,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(horizontal = 10.dp, vertical = 6.dp)
                )
            }
        }

        Spacer(modifier = Modifier.height(12.dp))

        // --- Holographic 3D Stage Visualizer Container ---
        Card(
            shape = RoundedCornerShape(24.dp),
            colors = CardDefaults.cardColors(containerColor = glassContainer),
            border = BorderStroke(1.dp, glassBorder),
            modifier = Modifier
                .fillMaxWidth()
                .shadow(16.dp, RoundedCornerShape(24.dp), spotColor = indigoAccent)
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "3D SPATIAL STAGE PERSPECTIVE",
                        color = textPrimary,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Bold
                    )
                    Text(
                        text = "${nodes.size} NODES IN FIELD",
                        color = cyanAccent,
                        fontSize = 10.sp,
                        fontFamily = FontFamily.Monospace
                    )
                }

                Spacer(modifier = Modifier.height(16.dp))

                // Interactive Radar Field Box
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(150.dp)
                        .clip(RoundedCornerShape(16.dp))
                        .background(Color(0x660B0F17))
                        .border(1.dp, Color(0x2200F0FF), RoundedCornerShape(16.dp)),
                    contentAlignment = Alignment.Center
                ) {
                    // Central User Orb
                    Box(
                        modifier = Modifier
                            .size(24.dp)
                            .clip(CircleShape)
                            .background(cyanAccent)
                            .shadow(12.dp, CircleShape, spotColor = cyanAccent)
                    )

                    // Node Orbs positioned around stage
                    nodes.forEachIndexed { idx, node ->
                        val offsetX = ((node.x - 2.5f) * 20).dp
                        val offsetY = ((node.y - 2.5f) * 15).dp
                        Box(
                            modifier = Modifier
                                .offset(x = offsetX, y = offsetY)
                                .size(16.dp)
                                .clip(CircleShape)
                                .background(if (idx % 2 == 0) emeraldAccent else indigoAccent)
                                .shadow(8.dp, CircleShape, spotColor = emeraldAccent)
                        )
                    }
                }

                Spacer(modifier = Modifier.height(14.dp))

                // Audio Waveform Equalizer Display
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(32.dp),
                    horizontalArrangement = Arrangement.SpaceEvenly,
                    verticalAlignment = Alignment.Bottom
                ) {
                    repeat(24) { index ->
                        val heightFraction = remember { (0.2f + (index % 5) * 0.18f).coerceAtMost(1.0f) }
                        Box(
                            modifier = Modifier
                                .width(6.dp)
                                .fillMaxHeight(heightFraction)
                                .clip(RoundedCornerShape(9999.dp))
                                .background(
                                    if (index % 3 == 0) cyanAccent else if (index % 2 == 0) indigoAccent else emeraldAccent
                                )
                        )
                    }
                }

                Spacer(modifier = Modifier.height(14.dp))

                // Stage Quick Controls
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Button(
                        onClick = { isStageMuted = !isStageMuted },
                        colors = ButtonDefaults.buttonColors(
                            containerColor = if (isStageMuted) Color(0x33FFB4AB) else Color(0x1F00F0FF)
                        ),
                        border = BorderStroke(1.dp, if (isStageMuted) Color(0xFFFFB4AB) else cyanAccent),
                        shape = RoundedCornerShape(12.dp)
                    ) {
                        Text(
                            text = if (isStageMuted) "🔇 Muted" else "🎙️ Stage Mic Live",
                            color = if (isStageMuted) Color(0xFFFFB4AB) else cyanAccent,
                            fontSize = 11.sp,
                            fontWeight = FontWeight.Bold
                        )
                    }

                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text(
                            text = "Spatial Gain: ",
                            color = textMuted,
                            fontSize = 11.sp
                        )
                        Text(
                            text = "${(spatialGainValue * 100).toInt()}%",
                            color = cyanAccent,
                            fontSize = 11.sp,
                            fontFamily = FontFamily.Monospace,
                            fontWeight = FontWeight.Bold
                        )
                    }
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        Text(
            text = "Active Spatial Nodes",
            color = textPrimary,
            fontSize = 18.sp,
            fontWeight = FontWeight.Bold
        )

        Spacer(modifier = Modifier.height(10.dp))

        // --- Node List ---
        LazyColumn(
            verticalArrangement = Arrangement.spacedBy(10.dp),
            modifier = Modifier.fillMaxSize()
        ) {
            items(nodes) { node ->
                Card(
                    shape = RoundedCornerShape(20.dp),
                    colors = CardDefaults.cardColors(containerColor = glassCard),
                    border = BorderStroke(1.dp, glassBorder),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(14.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Box(
                                modifier = Modifier
                                    .size(40.dp)
                                    .clip(CircleShape)
                                    .background(
                                        Brush.linearGradient(
                                            colors = listOf(indigoAccent, cyanAccent)
                                        )
                                    ),
                                contentAlignment = Alignment.Center
                            ) {
                                Text(
                                    text = node.name.take(1),
                                    color = Color.Black,
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 16.sp
                                )
                            }

                            Spacer(modifier = Modifier.width(12.dp))

                            Column {
                                Text(
                                    text = node.name,
                                    color = textPrimary,
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 14.sp
                                )
                                Text(
                                    text = "Position: (${node.x}, ${node.y}, ${node.z})",
                                    color = textMuted,
                                    fontSize = 11.sp,
                                    fontFamily = FontFamily.Monospace
                                )
                            }
                        }

                        Column(horizontalAlignment = Alignment.End) {
                            Surface(
                                shape = RoundedCornerShape(9999.dp),
                                color = Color(0x1F10B981),
                                border = BorderStroke(1.dp, Color(0x4D10B981))
                            ) {
                                Text(
                                    text = "Gain ${String.format("%.2f", node.gain)}",
                                    color = emeraldAccent,
                                    fontSize = 10.sp,
                                    fontFamily = FontFamily.Monospace,
                                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp)
                                )
                            }
                            Spacer(modifier = Modifier.height(4.dp))
                            Text(
                                text = "P2P Mesh Locked",
                                color = cyanAccent,
                                fontSize = 9.sp
                            )
                        }
                    }
                }
            }
        }
    }
}
