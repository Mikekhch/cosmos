package com.cosmos.app.ui

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
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
import com.cosmos.app.viewmodel.SecurityDashboardViewModel

@Composable
fun SecurityDashboardScreen(viewModel: SecurityDashboardViewModel = SecurityDashboardViewModel()) {
    val configState by viewModel.remoteConfigState.collectAsState()
    val isAuditPassed by viewModel.isAuditPassed.collectAsState()
    var isKeyRotated by remember { mutableStateOf(false) }

    val bgCanvas = Color(0xFF0F131C)
    val glassContainer = Color(0xBF181C24)
    val glassCard = Color(0x991C2028)
    val cyanAccent = Color(0xFF00F0FF)
    val indigoAccent = Color(0xFF6366F1)
    val emeraldAccent = Color(0xFF10B981)
    val errorAccent = Color(0xFFFFB4AB)
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
                        text = "SECURITY SHIELD",
                        color = cyanAccent,
                        fontSize = 22.sp,
                        fontWeight = FontWeight.Bold,
                        letterSpacing = (-0.5).sp
                    )
                    Text(
                        text = "4-Layer Zero-Trust Enterprise Integrity",
                        color = textMuted,
                        fontSize = 11.sp
                    )
                }

                Surface(
                    shape = RoundedCornerShape(9999.dp),
                    color = if (isAuditPassed) Color(0x1F10B981) else Color(0x1FFF3366),
                    border = BorderStroke(1.dp, if (isAuditPassed) Color(0x4D10B981) else Color(0x4DFF3366))
                ) {
                    Text(
                        text = if (isAuditPassed) "AUDIT PASSED" else "THREAT DETECTED",
                        color = if (isAuditPassed) emeraldAccent else errorAccent,
                        fontSize = 10.sp,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.padding(horizontal = 10.dp, vertical = 6.dp)
                    )
                }
            }
        }

        // --- Master Security Shield Status ---
        item {
            Card(
                shape = RoundedCornerShape(24.dp),
                colors = CardDefaults.cardColors(containerColor = glassContainer),
                border = BorderStroke(1.dp, glassBorder),
                modifier = Modifier
                    .fillMaxWidth()
                    .shadow(16.dp, RoundedCornerShape(24.dp), spotColor = if (isAuditPassed) emeraldAccent else errorAccent)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Box(
                                modifier = Modifier
                                    .size(12.dp)
                                    .clip(CircleShape)
                                    .background(if (isAuditPassed) emeraldAccent else errorAccent)
                                    .shadow(8.dp, CircleShape, spotColor = emeraldAccent)
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                text = "SYSTEM INTEGRITY STATUS",
                                color = textPrimary,
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Bold
                            )
                        }

                        Text(
                            text = "ENFORCED",
                            color = cyanAccent,
                            fontSize = 10.sp,
                            fontFamily = FontFamily.Monospace,
                            fontWeight = FontWeight.Bold
                        )
                    }

                    Spacer(modifier = Modifier.height(14.dp))

                    // 4 Layers Grid
                    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        SecurityLayerRow(
                            layerNum = "Layer 1",
                            layerName = "Firebase App Check",
                            detail = "DeviceCheck & App Attest Attested",
                            isOk = true,
                            accentColor = cyanAccent
                        )
                        SecurityLayerRow(
                            layerNum = "Layer 2",
                            layerName = "Sovereign CryptoKit",
                            detail = "AES-256-GCM E2EE & Secure Enclave",
                            isOk = true,
                            accentColor = indigoAccent
                        )
                        SecurityLayerRow(
                            layerNum = "Layer 3",
                            layerName = "AI Surveillance",
                            detail = "Burst & GPS Spoofing Detection",
                            isOk = isAuditPassed,
                            accentColor = emeraldAccent
                        )
                        SecurityLayerRow(
                            layerNum = "Layer 4",
                            layerName = "Root & Integrity Shield",
                            detail = "Anti-Jailbreak, Anti-Debug, SSL Pinning",
                            isOk = true,
                            accentColor = Color(0xFFC0C1FF)
                        )
                    }
                }
            }
        }

        // --- Key Rotation & Threat Remediation Actions ---
        item {
            Card(
                shape = RoundedCornerShape(20.dp),
                colors = CardDefaults.cardColors(containerColor = glassCard),
                border = BorderStroke(1.dp, glassBorder),
                modifier = Modifier.fillMaxWidth()
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        text = "CRYPTOGRAPHIC CONTROL & KEY ROTATION",
                        color = textPrimary,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Bold
                    )

                    Spacer(modifier = Modifier.height(8.dp))

                    Text(
                        text = "Re-derive HKDF master cryptographic keys across all active mesh nodes instantly.",
                        color = textMuted,
                        fontSize = 12.sp
                    )

                    Spacer(modifier = Modifier.height(14.dp))

                    Button(
                        onClick = {
                            viewModel.executeCryptographicKeyRotation()
                            isKeyRotated = true
                        },
                        colors = ButtonDefaults.buttonColors(containerColor = cyanAccent),
                        shape = RoundedCornerShape(16.dp),
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(48.dp)
                            .shadow(12.dp, RoundedCornerShape(16.dp), spotColor = cyanAccent)
                    ) {
                        Text(
                            text = if (isKeyRotated) "✓ Cryptographic Key Rotated & Synced" else "🔑 Rotate HKDF Master Cryptographic Keys",
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
private fun SecurityLayerRow(
    layerNum: String,
    layerName: String,
    detail: String,
    isOk: Boolean,
    accentColor: Color
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(12.dp))
            .background(Color(0x22000000))
            .padding(horizontal = 12.dp, vertical = 8.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    text = "$layerNum: ",
                    color = accentColor,
                    fontSize = 11.sp,
                    fontWeight = FontWeight.Bold
                )
                Text(
                    text = layerName,
                    color = Color.White,
                    fontSize = 12.sp,
                    fontWeight = FontWeight.SemiBold
                )
            }
            Text(
                text = detail,
                color = Color(0xFFB9CACB),
                fontSize = 10.sp
            )
        }

        Surface(
            shape = RoundedCornerShape(9999.dp),
            color = if (isOk) Color(0x1F10B981) else Color(0x1FFF3366)
        ) {
            Text(
                text = if (isOk) "ACTIVE" else "ALERT",
                color = if (isOk) Color(0xFF10B981) else Color(0xFFFFB4AB),
                fontSize = 9.sp,
                fontFamily = FontFamily.Monospace,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
            )
        }
    }
}
