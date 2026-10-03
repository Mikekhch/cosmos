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

@Composable
fun CreatorStudioScreen() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF0F131C))
            .padding(16.dp)
    ) {
        Text(
            text = "CREATOR STUDIO",
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
                Text(text = "3D Holographic Mesh Decimation", color = Color.White, fontWeight = FontWeight.Bold)
                Text(
                    text = "FFmpeg Server-Side Offloading Active (150k -> 35k polys)",
                    color = Color(0xFF65F2B5),
                    fontSize = 12.sp
                )
            }
        }
    }
}
