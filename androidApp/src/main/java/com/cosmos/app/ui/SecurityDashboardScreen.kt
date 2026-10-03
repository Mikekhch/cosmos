package com.cosmos.app.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.cosmos.app.viewmodel.SecurityDashboardViewModel

@Composable
fun SecurityDashboardScreen(viewModel: SecurityDashboardViewModel = SecurityDashboardViewModel()) {
    val configState by viewModel.remoteConfigState.collectAsState()
    val isAuditPassed by viewModel.isAuditPassed.collectAsState()

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF0F131C))
            .padding(16.dp)
    ) {
        Text(
            text = "4-LAYER SECURITY SHIELD",
            color = Color(0xFF00F0FF),
            fontSize = 22.sp,
            fontWeight = FontWeight.Bold
        )

        Spacer(modifier = Modifier.height(16.dp))

        Card(
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = Color(0xFF181C24)),
            modifier = Modifier.fillMaxWidth()
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text(
                    text = if (isAuditPassed) "SHIELD ACTIVE: PASSED" else "SHIELD THREAT DETECTED",
                    color = if (isAuditPassed) Color(0xFF65F2B5) else Color(0xFFFFB4AB),
                    fontWeight = FontWeight.Bold
                )
                Text(
                    text = "App Check | CryptoKit AES-256 | AI Surveillance | Root Shield",
                    color = Color(0xFFB9CACB),
                    fontSize = 12.sp
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        Button(
            onClick = { viewModel.executeCryptographicKeyRotation() },
            colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF00F0FF))
        ) {
            Text(text = "Rotate Master Key", color = Color.Black, fontWeight = FontWeight.Bold)
        }
    }
}
