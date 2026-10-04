package com.cosmos.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.List
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import com.cosmos.app.ui.CreatorStudioScreen
import com.cosmos.app.ui.HomeScreen
import com.cosmos.app.ui.SettingsScreen

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            var selectedTab by remember { mutableIntStateOf(0) }

            Scaffold(
                containerColor = Color(0xFF0F131C),
                bottomBar = {
                    NavigationBar(
                        containerColor = Color(0xFF181C24),
                        contentColor = Color.White
                    ) {
                        NavigationBarItem(
                            selected = selectedTab == 0,
                            onClick = { selectedTab = 0 },
                            label = { Text("Feed") },
                            icon = { Icon(Icons.Default.Home, contentDescription = "Feed") },
                            colors = NavigationBarItemDefaults.colors(
                                selectedIconColor = Color(0xFF00F0FF),
                                selectedTextColor = Color(0xFF00F0FF),
                                unselectedIconColor = Color.Gray,
                                unselectedTextColor = Color.Gray,
                                indicatorColor = Color(0xFF222834)
                            )
                        )
                        NavigationBarItem(
                            selected = selectedTab == 1,
                            onClick = { selectedTab = 1 },
                            label = { Text("Studio") },
                            icon = { Icon(Icons.Default.List, contentDescription = "Studio") },
                            colors = NavigationBarItemDefaults.colors(
                                selectedIconColor = Color(0xFF00F0FF),
                                selectedTextColor = Color(0xFF00F0FF),
                                unselectedIconColor = Color.Gray,
                                unselectedTextColor = Color.Gray,
                                indicatorColor = Color(0xFF222834)
                            )
                        )
                        NavigationBarItem(
                            selected = selectedTab == 2,
                            onClick = { selectedTab = 2 },
                            label = { Text("Settings") },
                            icon = { Icon(Icons.Default.Settings, contentDescription = "Settings") },
                            colors = NavigationBarItemDefaults.colors(
                                selectedIconColor = Color(0xFF00F0FF),
                                selectedTextColor = Color(0xFF00F0FF),
                                unselectedIconColor = Color.Gray,
                                unselectedTextColor = Color.Gray,
                                indicatorColor = Color(0xFF222834)
                            )
                        )
                    }
                }
            ) { innerPadding ->
                Surface(
                    modifier = Modifier.padding(innerPadding),
                    color = Color(0xFF0F131C)
                ) {
                    when (selectedTab) {
                        0 -> HomeScreen()
                        1 -> CreatorStudioScreen()
                        2 -> SettingsScreen()
                    }
                }
            }
        }
    }
}
