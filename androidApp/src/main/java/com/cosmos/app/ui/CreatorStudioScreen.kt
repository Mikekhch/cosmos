package com.cosmos.app.ui

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
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

@Composable
fun CreatorStudioScreen() {
    var isProcessing by remember { mutableStateOf(false) }
    var selectedCodec by remember { mutableStateOf("H.265 / AV1") }
    var decimationRatio by remember { mutableStateOf(0.75f) }

    val bgCanvas = Color(0xFF0F131C)
    val glassContainer = Color(0xBF181C24)
    val glassCard = Color(0x991C2028)
    val cyanAccent = Color(0xFF00F0FF)
    val indigoAccent = Color(0xFF6366F1)
    val emeraldAccent = Color(0xFF10B981)
    val glassBorder = Color(0x33FFFFFF)
    val textPrimary = Color(0xFFDFE2EE)
    val textMuted = Color(0xFFB9CACB)

    LazyColumn(
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
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        item {
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
                        text = "CREATOR STUDIO",
                        color = cyanAccent,
                        fontSize = 22.sp,
                        fontWeight = FontWeight.Bold,
                        letterSpacing = (-0.5).sp
                    )
                    Text(
                        text = "3D Holographic Mesh & FFmpeg Pipeline",
                        color = textMuted,
                        fontSize = 11.sp
                    )
                }

                Surface(
                    shape = RoundedCornerShape(9999.dp),
                    color = Color(0x1F10B981),
                    border = BorderStroke(1.dp, Color(0x4D10B981))
                ) {
                    Text(
                        text = "FFMPEG READY",
                        color = emeraldAccent,
                        fontSize = 10.sp,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.padding(horizontal = 10.dp, vertical = 6.dp)
                    )
                }
            }
        }

        // --- Holographic Mesh Preview Viewport ---
        item {
            Card(
                shape = RoundedCornerShape(24.dp),
                colors = CardDefaults.cardColors(containerColor = glassContainer),
                border = BorderStroke(1.dp, glassBorder),
                modifier = Modifier
                    .fillMaxWidth()
                    .shadow(16.dp, RoundedCornerShape(24.dp), spotColor = cyanAccent)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        text = "3D HOLOGRAM PREVIEW & MATTE EXTRACTOR",
                        color = textPrimary,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Bold
                    )

                    Spacer(modifier = Modifier.height(12.dp))

                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(180.dp)
                            .clip(RoundedCornerShape(16.dp))
                            .background(
                                Brush.linearGradient(
                                    colors = listOf(Color(0xFF181C24), Color(0xFF0B0F17))
                                )
                            )
                            .border(1.dp, Color(0x3300F0FF), RoundedCornerShape(16.dp)),
                        contentAlignment = Alignment.Center
                    ) {
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                            Box(
                                modifier = Modifier
                                    .size(64.dp)
                                    .clip(CircleShape)
                                    .background(
                                        Brush.linearGradient(
                                            colors = listOf(cyanAccent, indigoAccent)
                                        )
                                    )
                                    .shadow(16.dp, CircleShape, spotColor = cyanAccent),
                                contentAlignment = Alignment.Center
                            ) {
                                Text(
                                    text = "3D",
                                    color = Color.Black,
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 20.sp
                                )
                            }
                            Spacer(modifier = Modifier.height(8.dp))
                            Text(
                                text = "Volumetric Capture Active",
                                color = textPrimary,
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Bold
                            )
                            Text(
                                text = "150,000 Polygons → Target: 35,000 Polys",
                                color = cyanAccent,
                                fontSize = 10.sp,
                                fontFamily = FontFamily.Monospace
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(14.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = "Mesh Decimation Ratio",
                            color = textMuted,
                            fontSize = 12.sp
                        )
                        Text(
                            text = "${(decimationRatio * 100).toInt()}%",
                            color = cyanAccent,
                            fontSize = 12.sp,
                            fontFamily = FontFamily.Monospace,
                            fontWeight = FontWeight.Bold
                        )
                    }

                    Slider(
                        value = decimationRatio,
                        onValueChange = { decimationRatio = it },
                        colors = SliderDefaults.colors(
                            thumbColor = cyanAccent,
                            activeTrackColor = cyanAccent,
                            inactiveTrackColor = Color(0x33FFFFFF)
                        )
                    )
                }
            }
        }

        // --- Offload Processing Pipeline Settings ---
        item {
            Card(
                shape = RoundedCornerShape(20.dp),
                colors = CardDefaults.cardColors(containerColor = glassCard),
                border = BorderStroke(1.dp, glassBorder),
                modifier = Modifier.fillMaxWidth()
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        text = "SERVER-SIDE MEDIA OFFLOAD PIPELINE",
                        color = textPrimary,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Bold
                    )

                    Spacer(modifier = Modifier.height(12.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        StudioFeatureBadge(title = "AI Matte Removal", status = "ENABLED")
                        StudioFeatureBadge(title = "AV1 Transcode", status = "CLUSTER OK")
                        StudioFeatureBadge(title = "CDN Auto-Purge", status = "<300MB LIMIT")
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    Button(
                        onClick = { isProcessing = !isProcessing },
                        colors = ButtonDefaults.buttonColors(containerColor = cyanAccent),
                        shape = RoundedCornerShape(16.dp),
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(48.dp)
                            .shadow(12.dp, RoundedCornerShape(16.dp), spotColor = cyanAccent)
                    ) {
                        Text(
                            text = if (isProcessing) "⚡ Processing FFmpeg Pipeline..." else "🚀 Trigger Server Offload & Decimation",
                            color = Color.Black,
                            fontWeight = FontWeight.Bold,
                            fontSize = 13.sp
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun StudioFeatureBadge(title: String, status: String) {
    Column {
        Text(text = title, color = Color(0xFFB9CACB), fontSize = 10.sp)
        Text(
            text = status,
            color = Color(0xFF00F0FF),
            fontSize = 11.sp,
            fontFamily = FontFamily.Monospace,
            fontWeight = FontWeight.Bold
        )
    }
}
