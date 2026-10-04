package com.cosmos.app.ui

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.cosmos.app.viewmodel.SecurityDashboardViewModel

@Composable
fun SecurityDashboardScreen(viewModel: SecurityDashboardViewModel = SecurityDashboardViewModel()) {
    val isAuditPassed by viewModel.isAuditPassed.collectAsState()
    var appCheckEnabled by remember { mutableStateOf(true) }
    var e2eeEnabled by remember { mutableStateOf(true) }
    var keyRotatedMessage by remember { mutableStateOf<String?>(null) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        Text(
            text = "Settings & Security",
            fontSize = 24.sp,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.primary
        )

        Spacer(modifier = Modifier.height(16.dp))

        // System Shield Status Card
        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(
                containerColor = if (isAuditPassed) MaterialTheme.colorScheme.surfaceVariant else MaterialTheme.colorScheme.errorContainer
            )
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text(
                    text = if (isAuditPassed) "System Security: Healthy" else "System Threat Detected",
                    fontWeight = FontWeight.Bold,
                    fontSize = 16.sp
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    text = "4-Layer Protection Active (App Check, AES-256 E2EE, AI Surveillance, Root Shield)",
                    fontSize = 12.sp
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Security Toggles
        Card(
            modifier = Modifier.fillMaxWidth()
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column {
                        Text(text = "App Check Enforcement", fontWeight = FontWeight.SemiBold)
                        Text(text = "Attests app integrity with Firebase", fontSize = 12.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                    }
                    Switch(
                        checked = appCheckEnabled,
                        onCheckedChange = { appCheckEnabled = it }
                    )
                }

                Divider(modifier = Modifier.padding(vertical = 12.dp))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column {
                        Text(text = "End-to-End Encryption", fontWeight = FontWeight.SemiBold)
                        Text(text = "AES-256-GCM E2EE & HKDF", fontSize = 12.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                    }
                    Switch(
                        checked = e2eeEnabled,
                        onCheckedChange = { e2eeEnabled = it }
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Key Rotation Action
        Button(
            onClick = {
                viewModel.executeCryptographicKeyRotation()
                keyRotatedMessage = "Master cryptographic keys rotated successfully."
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text(text = "Rotate Cryptographic Master Key")
        }

        keyRotatedMessage?.let { msg ->
            Spacer(modifier = Modifier.height(8.dp))
            Text(text = msg, color = MaterialTheme.colorScheme.primary, fontSize = 12.sp)
        }
    }
}
