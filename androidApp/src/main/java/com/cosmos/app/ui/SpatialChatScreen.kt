package com.cosmos.app.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.cosmos.app.viewmodel.SpatialChatViewModel

@Composable
fun SpatialChatScreen(viewModel: SpatialChatViewModel = SpatialChatViewModel()) {
    val nodes by viewModel.nodes.collectAsState()

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF0F131C))
            .padding(16.dp)
    ) {
        Text(
            text = "Connected Nodes",
            color = Color(0xFF00F0FF),
            fontSize = 20.sp,
            fontWeight = FontWeight.Bold
        )

        Spacer(modifier = Modifier.height(12.dp))

        nodes.forEach { node ->
            Card(
                colors = CardDefaults.cardColors(containerColor = Color(0xFF181C24)),
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 4.dp)
            ) {
                Column(modifier = Modifier.padding(12.dp)) {
                    Text(text = node.name, color = Color.White, fontWeight = FontWeight.Bold)
                    Text(text = "Gain: ${String.format("%.2f", node.gain)}", color = Color(0xFF00F0FF), fontSize = 12.sp)
                }
            }
        }
    }
}
