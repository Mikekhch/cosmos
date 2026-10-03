package com.cosmos.app.viewmodel

import androidx.lifecycle.ViewModel
import com.cosmos.app.config.RemoteConfigManager
import com.cosmos.app.data.RemoteConfigState
import com.cosmos.app.data.Repository
import com.cosmos.app.data.SecurityEvent
import com.cosmos.app.security.AppCheckShield
import com.cosmos.app.security.CryptoShield
import com.cosmos.app.security.RootProtectionShield
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

class SecurityDashboardViewModel(
    private val repository: Repository = Repository(),
    val remoteConfigManager: RemoteConfigManager = RemoteConfigManager()
) : ViewModel() {

    val appCheckShield = AppCheckShield()
    val cryptoShield = CryptoShield()
    val rootProtectionShield = RootProtectionShield()

    val securityEvents: StateFlow<List<SecurityEvent>> = repository.securityEvents
    val remoteConfigState: StateFlow<RemoteConfigState> = remoteConfigManager.configState

    private val _isAuditPassed = MutableStateFlow(true)
    val isAuditPassed: StateFlow<Boolean> = _isAuditPassed.asStateFlow()

    fun runSecurityCheck() {
        val passed = appCheckShield.validateAppCheckToken() && rootProtectionShield.performFullSecurityAudit()
        _isAuditPassed.value = passed
    }

    fun toggleRemoteFlag(flagKey: String, currentValue: Boolean) {
        remoteConfigManager.updateFlag(flagKey, !currentValue)
    }

    fun executeCryptographicKeyRotation() {
        cryptoShield.rotateMasterKey()
        remoteConfigManager.triggerMasterKeyRotation()
    }

    fun banUserAccount(userId: String) {
        remoteConfigManager.moderateUserOrIP(userId, "BAN")
    }

    fun lockIPAddress(ip: String) {
        remoteConfigManager.moderateUserOrIP(ip, "LOCK_IP")
    }
}
