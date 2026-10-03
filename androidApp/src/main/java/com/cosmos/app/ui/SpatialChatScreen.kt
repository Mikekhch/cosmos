package com.cosmos.app.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
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
            text = "SPATIAL CHAT & 3D STAGE",
            color = Color(0xFF00F0FF),
            fontSize = 22.sp,
            fontWeight = FontWeight.Bold
        )

        Spacer(modifier = Modifier.height(16.dp))

        LazyColumn(verticalArrangement = Arrangement.spacedBy(12.dp)) {
            items(nodes) { node ->
                Card(
                    shape = RoundedCornerShape(16.dp),
                    colors = CardDefaults.cardColors(containerColor = Color(0xFF181C24))
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Text(text = node.name, color = Color.White, fontWeight = FontWeight.Bold)
                        Text(
                            text = "Coords: (${node.x}, ${node.y}, ${node.z}) | Spatial Gain: ${String.format("%.2f", node.gain)}",
                            color = Color(0xFF00F0FF),
                            fontSize = 12.sp
                        )
                    }
                }
            }
        }
    }
}
