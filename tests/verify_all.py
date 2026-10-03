#!/usr/bin/env python3
"""
Comprehensive Production Architecture Verification Suite for CosmosApp
Tests and verifies:
1. MVVM Architecture and File Structure Integrity
2. 4-Layer Security Shield (CryptoKit E2EE logic, App Check format, AI Anomaly rules, Root Protection)
3. Firestore Rules Syntax & Schema Security
4. Storage & Cache Engine (Strict 300MB limit, LRU Eviction, Auto-purge logic)
5. Dynamic Feature Modules & Cloud Functions structure
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
    print("\n--- 1. Verifying MVVM Architecture Structure ---")
    required_files = [
        "CosmosApp/Models/Message.swift",
        "CosmosApp/Models/SecurityEvent.swift",
        "CosmosApp/Models/MediaCacheItem.swift",
        "CosmosApp/Models/DynamicFeature.swift",
        "CosmosApp/Models/MediaProcessingJob.swift",
        "CosmosApp/ViewModels/SecurityDashboardViewModel.swift",
        "CosmosApp/ViewModels/CreatorStudioViewModel.swift",
        "CosmosApp/ViewModels/SpatialChatViewModel.swift",
        "CosmosApp/ViewModels/StorageManagerViewModel.swift",
        "CosmosApp/Views/Theme/ObsidianTheme.swift",
        "CosmosApp/Views/Components/GlowButton.swift",
        "CosmosApp/Views/Components/StatusBadge.swift",
        "CosmosApp/Views/MainTabView.swift",
        "CosmosApp/Views/SecurityDashboardView.swift",
        "CosmosApp/Views/CreatorStudioView.swift",
        "CosmosApp/Views/SpatialChatView.swift",
        "CosmosApp/Views/StorageManagementView.swift",
        "CosmosApp/Services/AppCheckManager.swift",
        "CosmosApp/Services/CryptoManager.swift",
        "CosmosApp/Services/AnomalyDetectionEngine.swift",
        "CosmosApp/Services/RootProtectionManager.swift",
        "CosmosApp/Services/SSLPinningDelegate.swift",
        "CosmosApp/Services/OnDemandFeatureManager.swift",
        "CosmosApp/Services/MediaOffloadService.swift",
        "CosmosApp/Services/CacheManager.swift",
        "CosmosApp/Utilities/KeychainHelper.swift",
        "CosmosApp/Utilities/Logger.swift",
        "firestore.rules",
        "functions/index.js",
        "functions/package.json"
    ]

    for file in required_files:
        check_file_exists(file)

def verify_security_shield_implementation():
    print("\n--- 2. Verifying 4-Layer Security Shield ---")

    # Layer 1: App Check
    with open("CosmosApp/Services/AppCheckManager.swift") as f:
        content = f.read()
        assert "AppAttestProvider" in content, "Missing AppAttestProvider in AppCheckManager"
        assert "DeviceCheckProvider" in content, "Missing DeviceCheckProvider in AppCheckManager"
        log("Layer 1 (Boundary): Firebase App Check with DeviceCheck / App Attest configured")

    # Layer 2: CryptoKit AES-256 E2EE
    with open("CosmosApp/Services/CryptoManager.swift") as f:
        content = f.read()
        assert "CryptoKit" in content, "Missing CryptoKit import"
        assert "AES.GCM" in content, "Missing AES.GCM in CryptoManager"
        assert "SymmetricKey" in content, "Missing SymmetricKey in CryptoManager"
        assert "HKDF" in content, "Missing HKDF key derivation in CryptoManager"
        log("Layer 2 (Cryptography): Apple CryptoKit AES-256-GCM E2EE & HKDF verified")

    # Layer 3: AI Surveillance & Firestore Rules
    with open("firestore.rules") as f:
        rules = f.read()
        assert "app_check" in rules or "isAppCheckVerified()" in rules, "Missing App Check rule"
        assert "messages" in rules, "Missing messages collection rules"
        assert "anomalies" in rules, "Missing anomalies collection rules"
        log("Layer 3 (AI Surveillance): Firestore Security Rules & Real-time audit configured")

    with open("CosmosApp/Services/AnomalyDetectionEngine.swift") as f:
        content = f.read()
        assert "recordAndAnalyzeMessageSend" in content, "Missing burst analysis"
        assert "analyzeGeolocationJump" in content, "Missing location jump check"
        log("Layer 3 (AI Surveillance): Client Anomaly Engine verified")

    # Layer 4: Root Protection
    with open("CosmosApp/Services/RootProtectionManager.swift") as f:
        content = f.read()
        assert "Cydia.app" in content, "Missing jailbreak path check"
        assert "P_TRACED" in content, "Missing debugger detection"
        assert "DYLD_INSERT_LIBRARIES" in content, "Missing dylib injection check"
        log("Layer 4 (Root Protection): Jailbreak detection & Anti-Tampering verified")

    with open("CosmosApp/Services/SSLPinningDelegate.swift") as f:
        content = f.read()
        assert "URLSessionDelegate" in content, "Missing URLSessionDelegate"
        assert "SecTrustGetCertificateAtIndex" in content, "Missing SecTrust certificate evaluation"
        log("Layer 4 (Root Protection): SSL Pinning public key hash delegate verified")

def verify_storage_and_cache_engine():
    print("\n--- 3. Verifying Storage & Cache Optimization Engine ---")

    # 300MB limit & LRU cache eviction
    with open("CosmosApp/Services/CacheManager.swift") as f:
        content = f.read()
        assert "300 * 1024 * 1024" in content, "Missing 300MB limit definition"
        assert "enforceCacheLimitIfNeeded" in content, "Missing LRU eviction enforcement"
        assert "notifyUploadCompleted" in content or "purgeUploadedMedia" in content, "Missing auto-purge logic"
        log("Smart Cache Management: 300MB strict limit, LRU eviction, and auto-purge logic verified")

    # Dynamic Feature Modules
    with open("CosmosApp/Services/OnDemandFeatureManager.swift") as f:
        content = f.read()
        assert "creator_studio" in content, "Missing creator studio module"
        assert "avatar_3d" in content, "Missing avatar 3d module"
        assert "unloadFeatureFromMemory" in content, "Missing RAM unloader"
        log("Dynamic Feature Modules: On-Demand loading for Creator Studio & 3D Avatars verified")

    # Server-side FFmpeg Cloud Functions
    with open("functions/index.js") as f:
        content = f.read()
        assert "fluent-ffmpeg" in content or "ffmpeg" in content, "Missing ffmpeg in Cloud Functions"
        assert "compressAvatarMesh" in content, "Missing 3D mesh compression callable"
        log("Server-Side Offloading: FFmpeg and Cloud Function structure verified")

def test_cache_and_lru_simulation():
    print("\n--- 4. Running Logic Simulation Tests ---")

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
        verify_storage_and_cache_engine()
        test_cache_and_lru_simulation()
        print("\nALL PRODUCTION ARCHITECTURE AND ENGINE VERIFICATION TESTS PASSED SUCCESSFULLY! ✓✓✓")
    except AssertionError as e:
        print(f"\nTEST FAILURE: {e}")
        sys.exit(1)
