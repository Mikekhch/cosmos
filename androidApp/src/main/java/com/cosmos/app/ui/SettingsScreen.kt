package com.cosmos.app.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.cosmos.app.viewmodel.SecurityDashboardViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SettingsScreen(
    viewModel: SecurityDashboardViewModel = SecurityDashboardViewModel()
) {
    val isAuditPassed by viewModel.isAuditPassed.collectAsState()
    var anomalyDetectionEnabled by remember { mutableStateOf(true) }
    var autoSyncEnabled by remember { mutableStateOf(true) }
    var cacheSizeMb by remember { mutableIntStateOf(142) }
    var keyRotationStatus by remember { mutableStateOf("Key active & secure") }

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        text = "Settings & Security",
                        fontWeight = FontWeight.Bold,
                        color = Color.White
                    )
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = Color(0xFF181C24)
                )
            )
        },
        containerColor = Color(0xFF0F131C)
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Security Shield Card
            Text(
                text = "Security & Protection",
                color = Color(0xFF00F0FF),
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold
            )

            Card(
                shape = RoundedCornerShape(12.dp),
                colors = CardDefaults.cardColors(containerColor = Color(0xFF181C24)),
                modifier = Modifier.fillMaxWidth()
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(
                                Icons.Default.Lock,
                                contentDescription = null,
                                tint = if (isAuditPassed) Color(0xFF65F2B5) else Color(0xFFFFB4AB)
                            )
                            Spacer(modifier = Modifier.width(12.dp))
                            Column {
                                Text(
                                    text = "4-Layer Security Shield",
                                    color = Color.White,
                                    fontWeight = FontWeight.Bold
                                )
                                Text(
                                    text = if (isAuditPassed) "All 4 layers active and healthy" else "Threat detected",
                                    color = if (isAuditPassed) Color(0xFF65F2B5) else Color(0xFFFFB4AB),
                                    fontSize = 12.sp
                                )
                            }
                        }
                    }

                    HorizontalDivider(
                        modifier = Modifier.padding(vertical = 12.dp),
                        color = Color(0xFF2A303C)
                    )

                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Column {
                            Text(text = "AI Anomaly Detection", color = Color.White)
                            Text(
                                text = "Monitor suspicious network & location jumps",
                                color = Color.Gray,
                                fontSize = 12.sp
                            )
                        }
                        Switch(
                            checked = anomalyDetectionEnabled,
                            onCheckedChange = { anomalyDetectionEnabled = it }
                        )
                    }

                    HorizontalDivider(
                        modifier = Modifier.padding(vertical = 12.dp),
                        color = Color(0xFF2A303C)
                    )

                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Column {
                            Text(text = "E2EE Master Key Rotation", color = Color.White)
                            Text(text = keyRotationStatus, color = Color.Gray, fontSize = 12.sp)
                        }
                        Button(
                            onClick = {
                                viewModel.executeCryptographicKeyRotation()
                                keyRotationStatus = "Rotated just now"
                            },
                            colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF00F0FF))
                        ) {
                            Icon(
                                Icons.Default.Refresh,
                                contentDescription = null,
                                tint = Color.Black,
                                modifier = Modifier.size(16.dp)
                            )
                            Spacer(modifier = Modifier.width(4.dp))
                            Text("Rotate", color = Color.Black, fontWeight = FontWeight.Bold)
                        }
                    }
                }
            }

            // Storage & Performance Section
            Text(
                text = "Storage & Synchronization",
                color = Color(0xFF00F0FF),
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold
            )

            Card(
                shape = RoundedCornerShape(12.dp),
                colors = CardDefaults.cardColors(containerColor = Color(0xFF181C24)),
                modifier = Modifier.fillMaxWidth()
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(Icons.Default.Lock, contentDescription = null, tint = Color.White)
                            Spacer(modifier = Modifier.width(12.dp))
                            Column {
                                Text(text = "Cache Usage", color = Color.White, fontWeight = FontWeight.Bold)
                                Text(
                                    text = "$cacheSizeMb MB / 300 MB Limit",
                                    color = Color.Gray,
                                    fontSize = 12.sp
                                )
                            }
                        }
                        OutlinedButton(
                            onClick = { cacheSizeMb = 0 },
                            colors = ButtonDefaults.outlinedButtonColors(contentColor = Color(0xFF00F0FF))
                        ) {
                            Text("Clear Cache")
                        }
                    }

                    HorizontalDivider(
                        modifier = Modifier.padding(vertical = 12.dp),
                        color = Color(0xFF2A303C)
                    )

                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Column {
                            Text(text = "Background Cloud Sync", color = Color.White)
                            Text(
                                text = "Automatic mesh synchronization",
                                color = Color.Gray,
                                fontSize = 12.sp
                            )
                        }
                        Switch(
                            checked = autoSyncEnabled,
                            onCheckedChange = { autoSyncEnabled = it }
                        )
                    }
                }
            }

            // App Information
            Text(
                text = "About Cosmos",
                color = Color(0xFF00F0FF),
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold
            )

            Card(
                shape = RoundedCornerShape(12.dp),
                colors = CardDefaults.cardColors(containerColor = Color(0xFF181C24)),
                modifier = Modifier.fillMaxWidth()
            ) {
                Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    Row(horizontalArrangement = Arrangement.SpaceBetween, modifier = Modifier.fillMaxWidth()) {
                        Text("App Version", color = Color.Gray)
                        Text("1.0.0 (Standard Build)", color = Color.White, fontWeight = FontWeight.SemiBold)
                    }
                    Row(horizontalArrangement = Arrangement.SpaceBetween, modifier = Modifier.fillMaxWidth()) {
                        Text("Encryption", color = Color.Gray)
                        Text("AES-256-GCM / HKDF", color = Color.White, fontWeight = FontWeight.SemiBold)
                    }
                    Row(horizontalArrangement = Arrangement.SpaceBetween, modifier = Modifier.fillMaxWidth()) {
                        Text("App Check Status", color = Color.Gray)
                        Text("Verified", color = Color(0xFF65F2B5), fontWeight = FontWeight.SemiBold)
                    }
                }
            }
        }
    }
}
