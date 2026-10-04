package com.cosmos.app.ui

import androidx.compose.runtime.Composable
import com.cosmos.app.viewmodel.SecurityDashboardViewModel

@Composable
fun SecurityDashboardScreen(viewModel: SecurityDashboardViewModel = SecurityDashboardViewModel()) {
    SettingsScreen(viewModel = viewModel)
}
