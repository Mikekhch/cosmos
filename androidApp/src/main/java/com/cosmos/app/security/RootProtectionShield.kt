package com.cosmos.app.security

import java.io.File

class RootProtectionShield {
    private val rootPaths = listOf(
        "/system/app/Superuser.apk",
        "/sbin/su",
        "/system/bin/su",
        "/system/xbin/su",
        "/data/local/xbin/su",
        "/data/local/bin/su",
        "/system/sd/xbin/su",
        "/system/bin/failsafe/su",
        "/data/local/su"
    )

    fun isDeviceRooted(): Boolean {
        for (path in rootPaths) {
            if (File(path).exists()) return true
        }
        return false
    }

    fun isDebuggerConnected(): Boolean {
        return android.os.Debug.isDebuggerConnected()
    }

    fun verifySslCertificateHash(certHash: String, expectedHash: String): Boolean {
        return certHash.equals(expectedHash, ignoreCase = true)
    }

    fun performFullSecurityAudit(): Boolean {
        return !isDeviceRooted() && !isDebuggerConnected()
    }
}
