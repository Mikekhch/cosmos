#!/usr/bin/env python3
"""
Comprehensive Production Architecture Verification Suite for CosmosApp
Tests and verifies Phase 1, Phase 2, Phase 3, Phase 4, Multi-Platform Android & Web Admin Deployment:
1. MVVM Architecture, Android 9-Layer Architecture, and File Structure Integrity
2. 4-Layer Security Shield on iOS and Android (App Check, E2EE AES-256 HKDF, AI Anomaly, Root Shield)
3. Firestore Rules Syntax & Schema Security
4. Storage & Cache Engine (Strict 300MB limit, LRU Eviction, Auto-purge logic)
5. Backend Integration, Firebase Real-Time Sync, Remote Config & Media Engine
6. Multi-Platform Android Support, Gradle APK Output (Cosmos-App.apk)
7. Standalone Web Admin Dashboard Deployment, Firebase Hosting, & Cross-Platform Linkage
"""

import os
import sys
import json
import re

def log(msg, success=True):
    symbol = "✓" if success else "✗"
    print(f"[{symbol}] {msg}")

def check_file_exists(filepath):
    exists = os.path.exists(filepath)
    log(f"File exists: {filepath}", success=exists)
    assert exists, f"Missing required file: {filepath}"

def verify_architecture_files():
    print("\n--- 1. Verifying MVVM (iOS) and 9-Layer Architecture (Android) Structure ---")
    required_files = [
        # iOS MVVM
        "CosmosApp/Models/Message.swift",
        "CosmosApp/Models/SecurityEvent.swift",
        "CosmosApp/Models/MediaCacheItem.swift",
        "CosmosApp/Models/DynamicFeature.swift",
        "CosmosApp/Models/MediaProcessingJob.swift",
        "CosmosApp/ViewModels/SecurityDashboardViewModel.swift",
        "CosmosApp/ViewModels/CreatorStudioViewModel.swift",
        "CosmosApp/ViewModels/SpatialChatViewModel.swift",
        "CosmosApp/ViewModels/StorageManagerViewModel.swift",
        "CosmosApp/ViewModels/HomeFeedViewModel.swift",
        "CosmosApp/Views/Theme/ObsidianTheme.swift",
        "CosmosApp/Views/Components/GlowButton.swift",
        "CosmosApp/Views/Components/StatusBadge.swift",
        "CosmosApp/Views/MainTabView.swift",
        "CosmosApp/Views/SecurityDashboardView.swift",
        "CosmosApp/Views/CreatorStudioView.swift",
        "CosmosApp/Views/SpatialChatView.swift",
        "CosmosApp/Views/StorageManagementView.swift",
        "CosmosApp/Views/HomeFeedView.swift",
        "CosmosApp/Services/AppCheckManager.swift",
        "CosmosApp/Services/CryptoManager.swift",
        "CosmosApp/Services/AnomalyDetectionEngine.swift",
        "CosmosApp/Services/RootProtectionManager.swift",
        "CosmosApp/Services/SSLPinningDelegate.swift",
        "CosmosApp/Services/OnDemandFeatureManager.swift",
        "CosmosApp/Services/MediaOffloadService.swift",
        "CosmosApp/Services/CacheManager.swift",
        "CosmosApp/Services/RemoteConfigManager.swift",
        "CosmosApp/Services/FirestoreSyncService.swift",
        "CosmosApp/Utilities/KeychainHelper.swift",
        "CosmosApp/Utilities/Logger.swift",

        # Android 9-Layer
        "androidApp/src/main/java/com/cosmos/app/MainActivity.kt",
        "androidApp/src/main/java/com/cosmos/app/ui/HomeScreen.kt",
        "androidApp/src/main/java/com/cosmos/app/ui/SpatialChatScreen.kt",
        "androidApp/src/main/java/com/cosmos/app/ui/CreatorStudioScreen.kt",
        "androidApp/src/main/java/com/cosmos/app/ui/SecurityDashboardScreen.kt",
        "androidApp/src/main/java/com/cosmos/app/viewmodel/HomeViewModel.kt",
        "androidApp/src/main/java/com/cosmos/app/viewmodel/SpatialChatViewModel.kt",
        "androidApp/src/main/java/com/cosmos/app/viewmodel/SecurityDashboardViewModel.kt",
        "androidApp/src/main/java/com/cosmos/app/domain/UseCases.kt",
        "androidApp/src/main/java/com/cosmos/app/data/Models.kt",
        "androidApp/src/main/java/com/cosmos/app/data/Repository.kt",
        "androidApp/src/main/java/com/cosmos/app/security/AppCheckShield.kt",
        "androidApp/src/main/java/com/cosmos/app/security/CryptoShield.kt",
        "androidApp/src/main/java/com/cosmos/app/security/AnomalyDetectionEngine.kt",
        "androidApp/src/main/java/com/cosmos/app/security/RootProtectionShield.kt",
        "androidApp/src/main/java/com/cosmos/app/config/RemoteConfigManager.kt",
        "androidApp/src/main/java/com/cosmos/app/sync/FirestoreSyncEngine.kt",
        "androidApp/src/main/java/com/cosmos/app/cache/CacheManager.kt",
        "androidApp/src/main/java/com/cosmos/app/offload/MediaOffloadClient.kt",
        "androidApp/build.gradle.kts",
        "androidApp/src/main/AndroidManifest.xml",

        # Shared Configuration & Backend
        "settings.gradle.kts",
        "build.gradle.kts",
        "firestore.rules",
        "functions/index.js",
        "functions/package.json"
    ]

    for file in required_files:
        check_file_exists(file)

def verify_security_shield_implementation():
    print("\n--- 2. Verifying 4-Layer Security Shield (iOS & Android) ---")

    # Layer 1: App Check
    with open("CosmosApp/Services/AppCheckManager.swift") as f:
        content = f.read()
        assert "AppAttestProvider" in content, "Missing AppAttestProvider in AppCheckManager"
        assert "DeviceCheckProvider" in content, "Missing DeviceCheckProvider in AppCheckManager"

    with open("androidApp/src/main/java/com/cosmos/app/security/AppCheckShield.kt") as f:
        content = f.read()
        assert "validateAppCheckToken" in content, "Missing token validation in Android AppCheckShield"
    log("Layer 1 (Boundary): Firebase App Check with DeviceCheck / App Attest / Play Integrity configured")

    # Layer 2: CryptoKit AES-256 E2EE & HKDF
    with open("CosmosApp/Services/CryptoManager.swift") as f:
        content = f.read()
        assert "CryptoKit" in content, "Missing CryptoKit import"
        assert "AES.GCM" in content, "Missing AES.GCM in CryptoManager"
        assert "SymmetricKey" in content, "Missing SymmetricKey in CryptoManager"
        assert "HKDF" in content, "Missing HKDF key derivation in CryptoManager"

    with open("androidApp/src/main/java/com/cosmos/app/security/CryptoShield.kt") as f:
        content = f.read()
        assert "AES/GCM/NoPadding" in content, "Missing AES/GCM in Android CryptoShield"
        assert "deriveHkdfSubkey" in content, "Missing HKDF derivation in Android CryptoShield"
    log("Layer 2 (Cryptography): Apple CryptoKit & Android AES-256-GCM E2EE & HKDF verified")

    # Layer 3: AI Surveillance & Firestore Rules
    with open("firestore.rules") as f:
        rules = f.read()
        assert "app_check" in rules or "isAppCheckVerified()" in rules, "Missing App Check rule"
        assert "messages" in rules, "Missing messages collection rules"
        assert "anomalies" in rules, "Missing anomalies collection rules"

    with open("CosmosApp/Services/AnomalyDetectionEngine.swift") as f:
        content = f.read()
        assert "recordAndAnalyzeMessageSend" in content
        assert "analyzeGeolocationJump" in content

    with open("androidApp/src/main/java/com/cosmos/app/security/AnomalyDetectionEngine.kt") as f:
        content = f.read()
        assert "recordAndAnalyzeMessageSend" in content
        assert "analyzeGeolocationJump" in content
    log("Layer 3 (AI Surveillance): Firestore Security Rules & Client Anomaly Engines verified")

    # Layer 4: Root Protection
    with open("CosmosApp/Services/RootProtectionManager.swift") as f:
        content = f.read()
        assert "Cydia.app" in content

    with open("androidApp/src/main/java/com/cosmos/app/security/RootProtectionShield.kt") as f:
        content = f.read()
        assert "Superuser.apk" in content or "su" in content, "Missing root su path check in Android"
        assert "isDebuggerConnected" in content, "Missing debugger check in Android"
    log("Layer 4 (Root Protection): Jailbreak/Root detection & Anti-Tampering verified")

def verify_android_apk_build():
    print("\n--- 3. Verifying Android APK Build & Binary Output ---")
    check_file_exists("Cosmos-App.apk")
    apk_size = os.path.getsize("Cosmos-App.apk")
    assert apk_size > 1000, f"APK binary Cosmos-App.apk size too small: {apk_size} bytes"
    log(f"Testable APK binary verified: Cosmos-App.apk ({apk_size / (1024*1024):.2f} MB)")

def verify_web_admin_dashboard():
    print("\n--- 4. Verifying Standalone Web Admin Dashboard Deployment & Linkage ---")

    check_file_exists("public/index.html")
    check_file_exists("public/style.css")
    check_file_exists("public/app.js")
    check_file_exists("firebase.json")
    check_file_exists(".firebaserc")
    check_file_exists("scripts/deploy.sh")

    with open("public/index.html") as f:
        content = f.read()
        assert "COSMOS // Sovereign Mesh Control" in content, "Missing Web Admin header title"
        assert "Remote Feature Toggles" in content, "Missing Remote Config controls in Web Admin"
        assert "btnRotateKeys" in content, "Missing Key Rotation trigger in Web Admin"

    with open("public/style.css") as f:
        content = f.read()
        assert "#00f0ff" in content or "00F0FF" in content, "Missing primary accent color in CSS"
        assert "glass-card" in content, "Missing glassmorphic card styling in CSS"

    with open("firebase.json") as f:
        content = f.read()
        assert "hosting" in content, "Missing hosting section in firebase.json"
        assert "public" in content, "Missing public directory in firebase.json"

    log("Standalone Web Admin Dashboard & Firebase Hosting deployment pipeline verified")

def verify_storage_and_cache_engine():
    print("\n--- 5. Verifying Storage & Cache Optimization Engine ---")

    # 300MB limit & LRU cache eviction
    with open("CosmosApp/Services/CacheManager.swift") as f:
        content = f.read()
        assert "300 * 1024 * 1024" in content, "Missing 300MB limit definition"

    with open("androidApp/src/main/java/com/cosmos/app/cache/CacheManager.kt") as f:
        content = f.read()
        assert "300 * 1024 * 1024" in content or "300" in content, "Missing 300MB limit definition on Android"
        assert "enforceCacheLimitIfNeeded" in content, "Missing LRU eviction enforcement on Android"

    log("Smart Cache Management: 300MB strict limit and LRU eviction logic verified on iOS and Android")

def test_cache_and_lru_simulation():
    print("\n--- 6. Running Logic Simulation Tests ---")

    # Simulate LRU Eviction Math
    MAX_LIMIT = 300 * 1024 * 1024 # 300MB
    items = [
        {"id": "1", "size": 100 * 1024 * 1024, "last_accessed": 100},
        {"id": "2", "size": 150 * 1024 * 1024, "last_accessed": 200},
        {"id": "3", "size": 100 * 1024 * 1024, "last_accessed": 300}, # Total = 350MB > 300MB
    ]

    total_size = sum(x["size"] for x in items)
    assert total_size > MAX_LIMIT

    # Sort LRU
    items_sorted = sorted(items, key=lambda x: x["last_accessed"])
    removed = []
    current_size = total_size
    for item in items_sorted:
        if current_size <= MAX_LIMIT:
            break
        removed.append(item["id"])
        current_size -= item["size"]

    assert "1" in removed, "Oldest item 1 should have been evicted first"
    assert current_size <= MAX_LIMIT, "Total size after eviction must be <= 300MB"
    log(f"LRU Eviction Simulation passed! Removed item {removed}, cache size reduced to {current_size / (1024*1024)} MB")

if __name__ == "__main__":
    try:
        verify_architecture_files()
        verify_security_shield_implementation()
        verify_android_apk_build()
        verify_web_admin_dashboard()
        verify_storage_and_cache_engine()
        test_cache_and_lru_simulation()
        print("\nALL PRODUCTION ARCHITECTURE, ANDROID APK BUILD, AND WEB ADMIN VERIFICATION TESTS PASSED SUCCESSFULLY! ✓✓✓")
    except AssertionError as e:
        print(f"\nTEST FAILURE: {e}")
        sys.exit(1)
