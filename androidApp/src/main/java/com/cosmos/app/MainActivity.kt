package com.cosmos.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import com.cosmos.app.ui.HomeScreen
import com.cosmos.app.ui.SpatialChatScreen
import com.cosmos.app.ui.CreatorStudioScreen
import com.cosmos.app.ui.SecurityDashboardScreen

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            var selectedTab by remember { mutableIntStateOf(0) }

            Scaffold(
                containerColor = Color(0xFF0F131C),
                bottomBar = {
                    NavigationBar(containerColor = Color(0xFF181C24)) {
                        NavigationBarItem(
                            selected = selectedTab == 0,
                            onClick = { selectedTab = 0 },
                            label = { Text("Feed", color = Color.White) },
                            icon = {}
                        )
                        NavigationBarItem(
                            selected = selectedTab == 1,
                            onClick = { selectedTab = 1 },
                            label = { Text("Spatial", color = Color.White) },
                            icon = {}
                        )
                        NavigationBarItem(
                            selected = selectedTab == 2,
                            onClick = { selectedTab = 2 },
                            label = { Text("Studio", color = Color.White) },
                            icon = {}
                        )
                        NavigationBarItem(
                            selected = selectedTab == 3,
                            onClick = { selectedTab = 3 },
                            label = { Text("Security", color = Color.White) },
                            icon = {}
                        )
                    }
                }
            ) { innerPadding ->
                Surface(modifier = Modifier.padding(innerPadding), color = Color(0xFF0F131C)) {
                    when (selectedTab) {
                        0 -> HomeScreen()
                        1 -> SpatialChatScreen()
                        2 -> CreatorStudioScreen()
                        3 -> SecurityDashboardScreen()
                    }
                }
            }
        }
    }
}
