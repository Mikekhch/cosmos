//
//  SecurityDashboardView.swift
//  CosmosApp
//
//  Profile & Security Center View (3D Holographic Avatar Stage, Enterprise 4-Layer Security Shield, Remote Admin Controls, Passkeys & Biometrics, Privacy Telemetry, Family Mesh)
//

import SwiftUI

public struct SecurityDashboardView: View {
    @StateObject private var viewModel = SecurityDashboardViewModel()

    public init() {}

    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // 1. Profile Hero & 3D Interactive Avatar Stage
                profileHeroStage

                // 2. Enterprise Remote Admin Interface & Live Dashboard
                remoteAdminControlsSection

                // 3. Cloud FFmpeg Pipeline & Live Network Analytics Monitor
                cloudFFmpegAnalyticsSection

                // 4. Cryptographic Key Rotation & Security Moderation
                keyRotationAndModerationSection

                // 5. Enterprise 4-Layer Security Shield Cards
                enterpriseSecurityShieldSection

                // 6. E2EE Interactive Test Bench & Audit Log
                e2eeTestBenchSection

                // 7. Passkey & Biometric Suite
                passkeyBiometricsSection

                // 8. E2EE Privacy Telemetry
                privacyTelemetrySection

                // 9. Family Mesh & Governance Dashboard
                familyGovernanceSection

                // 10. Logout & Emergency Lockdown
                emergencyLockdownSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .padding(.bottom, 100)
        }
        .background(
            ZStack {
                ObsidianTheme.darkBackground.ignoresSafeArea()
                Circle()
                    .fill(ObsidianTheme.secondaryIndigo.opacity(0.12))
                    .blur(radius: 120)
                    .frame(width: 320, height: 320)
                    .offset(x: -120, y: -100)
            }
        )
        .onAppear {
            viewModel.refreshAllSecurityLayers()
        }
    }

    // MARK: - Subviews

    private var profileHeroStage: some View {
        VStack(spacing: 16) {
            // 3D Avatar Stage Box
            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.black.opacity(0.8))
                    .frame(height: 240)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(ObsidianTheme.primaryCyan.opacity(0.3), lineWidth: 1)
                    )

                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .stroke(ObsidianTheme.primaryCyan, lineWidth: 1)
                            .frame(width: 90, height: 90)

                        Circle()
                            .stroke(ObsidianTheme.secondaryIndigo, lineWidth: 1)
                            .frame(width: 60, height: 60)

                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(ObsidianTheme.primaryCyan)
                            .shadow(color: ObsidianTheme.primaryCyan, radius: 10)
                    }

                    Text("HOLO-MESH // SYNAPSE 99.8%")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.primaryCyan)
                }

                VStack {
                    HStack {
                        StatusBadge(text: "ROTATABLE 3D CORE", color: ObsidianTheme.secondaryIndigo)
                        Spacer()
                        StatusBadge(text: "TIER 4 SOVEREIGN", color: ObsidianTheme.tertiaryEmerald)
                    }

                    Spacer()

                    HStack {
                        Text(viewModel.sovereignNodeHash)
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(Color.white.opacity(0.7))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(10)

                        Spacer()
                    }
                }
                .padding(12)
            }

            // Profile Metadata
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text(viewModel.userName)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(ObsidianTheme.primaryCyan)
                        }
                        Text(viewModel.userHandle)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(Color.white.opacity(0.6))
                    }

                    Spacer()

                    StatusBadge(text: viewModel.validatorLevel, color: ObsidianTheme.secondaryIndigo)
                }

                Text("\(viewModel.userRole) · Trust Index \(viewModel.trustIndex)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(ObsidianTheme.tertiaryEmerald)

                HStack(spacing: 12) {
                    GlowButton(title: "Edit 3D Persona", iconName: "cube.fill") {}

                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "key.fill")
                            Text("Share Public Key")
                        }
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(20)
                    }
                }
            }
        }
        .padding(16)
        .obsidianGlassCard(cornerRadius: 30)
    }

    private var remoteAdminControlsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(ObsidianTheme.primaryCyan)
                    Text("Enterprise Admin Remote Interface")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                StatusBadge(text: "REMOTE CONFIG", color: ObsidianTheme.primaryCyan)
            }

            Text("Wire remote feature flags to dynamically enable/disable feature modules, security layers, and UI feeds without app updates.")
                .font(.system(size: 11))
                .foregroundColor(Color.white.opacity(0.6))

            // Toggle 1: Spatial Feed
            Toggle(isOn: Binding(
                get: { viewModel.isSpatialFeedEnabled },
                set: { viewModel.toggleRemoteFlag(flagKey: "isSpatialFeedEnabled", value: $0) }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Spatial Canvas Feed")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    Text("Dynamic AR Geo-Feed Layer")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.5))
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: ObsidianTheme.primaryCyan))
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)

            // Toggle 2: Creator Studio
            Toggle(isOn: Binding(
                get: { viewModel.isCreatorStudioEnabled },
                set: { viewModel.toggleRemoteFlag(flagKey: "isCreatorStudioEnabled", value: $0) }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Creator Studio Module")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    Text("On-Demand AR Reels & Tagging")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.5))
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: ObsidianTheme.primaryCyan))
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)

            // Toggle 3: E-Commerce Feature
            Toggle(isOn: Binding(
                get: { viewModel.isEcommerceEnabled },
                set: { viewModel.toggleRemoteFlag(flagKey: "isEcommerceEnabled", value: $0) }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("E-Commerce & Micro-Mints")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    Text("Spatial Marketplace Engine")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.5))
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: ObsidianTheme.primaryCyan))
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)

            // Toggle 4: 9 Security Layers Global Toggle
            Toggle(isOn: Binding(
                get: { viewModel.isNineLayerShieldActive },
                set: { viewModel.toggleRemoteFlag(flagKey: "isNineLayerShieldActive", value: $0) }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("9-Layer Security Shield Enforcement")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    Text("Enforces 9-Layer Defense-in-Depth Protocols")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(ObsidianTheme.tertiaryEmerald)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: ObsidianTheme.tertiaryEmerald))
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)

            // Toggle 5: Maintenance Mode
            Toggle(isOn: Binding(
                get: { viewModel.isMaintenanceModeActive },
                set: { viewModel.toggleRemoteFlag(flagKey: "isMaintenanceModeActive", value: $0) }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Maintenance Mode")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    Text("Global System Maintenance State")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.orange)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .orange))
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)

            // Network Simulation Buttons
            HStack(spacing: 10) {
                Button(action: { viewModel.simulateNetworkOffline() }) {
                    Text("Simulate Offline")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.orange.opacity(0.15))
                        .cornerRadius(12)
                }

                Button(action: { viewModel.simulateNetworkOnline() }) {
                    Text("Simulate Online")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.tertiaryEmerald)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(ObsidianTheme.tertiaryEmerald.opacity(0.15))
                        .cornerRadius(12)
                }
            }
        }
        .padding(16)
        .obsidianGlassCard(cornerRadius: 24)
    }

    private var cloudFFmpegAnalyticsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "cpu.fill")
                        .foregroundColor(ObsidianTheme.secondaryIndigo)
                    Text("Live Network & FFmpeg Pipeline Monitor")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                StatusBadge(text: "LIVE METRICS", color: ObsidianTheme.secondaryIndigo)
            }

            // Grid Metrics
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("SOVEREIGN NODES")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.5))
                    Text("\(viewModel.activeSovereignNodes)")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.primaryCyan)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 4) {
                    Text("THROUGHPUT")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.5))
                    Text("\(String(format: "%.1f", viewModel.meshThroughputGbps)) Gbps")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.tertiaryEmerald)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
            }

            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("FFMPEG WORKERS")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.5))
                    Text("\(viewModel.ffmpegActiveWorkers) Workers Active")
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 4) {
                    Text("FFMPEG QUEUE")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.5))
                    Text("\(viewModel.ffmpegQueuedJobs) Transcodes Queued")
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.secondaryIndigo)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
            }
        }
        .padding(16)
        .obsidianGlassCard(cornerRadius: 24)
    }

    private var keyRotationAndModerationSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "key.icu.fill")
                        .foregroundColor(ObsidianTheme.tertiaryEmerald)
                    Text("Cryptographic Key Rotation & User Moderation")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                StatusBadge(text: "ADMIN SHIELD", color: ObsidianTheme.tertiaryEmerald)
            }

            // Key Version
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Master Key Version")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    Text(viewModel.currentMasterKeyVersion)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(ObsidianTheme.primaryCyan)
                }
                Spacer()
                Button(action: { viewModel.executeCryptographicKeyRotation() }) {
                    Text("Rotate Master Key")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(ObsidianTheme.tertiaryEmerald)
                        .cornerRadius(12)
                }
            }
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)

            // Moderation Controls
            VStack(alignment: .leading, spacing: 8) {
                Text("USER & IP SECURITY MODERATION")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.white.opacity(0.5))

                HStack {
                    TextField("Target User ID...", text: $viewModel.moderationTargetUserId)
                        .padding(8)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .font(.system(size: 11, design: .monospaced))

                    Button(action: { viewModel.banUserAccount() }) {
                        Text("Ban User")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(Color.red.opacity(0.8))
                            .cornerRadius(10)
                    }
                }

                HStack {
                    TextField("Target IP Address...", text: $viewModel.moderationTargetIp)
                        .padding(8)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .font(.system(size: 11, design: .monospaced))

                    Button(action: { viewModel.lockIPAddress() }) {
                        Text("IP Lock")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(Color.orange.opacity(0.8))
                            .cornerRadius(10)
                    }
                }

                Text("Status: \(viewModel.moderationStatusMessage)")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(Color.white.opacity(0.7))
            }
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
        }
        .padding(16)
        .obsidianGlassCard(cornerRadius: 24)
    }

    private var enterpriseSecurityShieldSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "shield.3c.fill")
                        .foregroundColor(ObsidianTheme.tertiaryEmerald)
                    Text("Enterprise Trust Architecture")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                StatusBadge(text: "4/4 OPERATIONAL", color: ObsidianTheme.tertiaryEmerald)
            }

            // Layer 1
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Layer 1: QKD & App Attest (Boundary)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    Text("Firebase App Check / AES-256-GCM")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.6))
                }
                Spacer()
                StatusBadge(text: viewModel.isAppCheckValid ? "OPTIMAL" : "ATTESTED", color: ObsidianTheme.tertiaryEmerald)
            }
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)

            // Layer 2
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Layer 2: FIDO2 / Apple Secure Enclave")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    Text("Bound to Hardware Enclave HKDF")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.6))
                }
                Spacer()
                StatusBadge(text: "BOUND", color: ObsidianTheme.tertiaryEmerald)
            }
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)

            // Layer 3
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Layer 3: AI Surveillance & ZK Vault")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    Text("zk-SNARK Circuit v4.2")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.6))
                }
                Spacer()
                StatusBadge(text: "VERIFIED", color: ObsidianTheme.tertiaryEmerald)
            }
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)

            // Layer 4
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Layer 4: Multi-Sig Node Recovery Mesh")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    Text("Shamir's Threshold 3/5 Active")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.6))
                }
                Spacer()
                StatusBadge(text: "3 OF 5 ACTIVE", color: ObsidianTheme.primaryCyan)
            }
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
        }
        .padding(16)
        .obsidianGlassCard(cornerRadius: 24)
    }

    private var e2eeTestBenchSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lock.square.stack.fill")
                    .foregroundColor(ObsidianTheme.primaryCyan)
                Text("E2EE Interactive Encryption Test Bench")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }

            TextField("Text to encrypt...", text: $viewModel.testPayloadInput)
                .padding(10)
                .background(Color.black.opacity(0.4))
                .cornerRadius(10)
                .foregroundColor(.white)

            HStack {
                GlowButton(title: "Encrypt & Test E2EE", iconName: "lock.fill") {
                    viewModel.testE2EEEncryption()
                }

                Button(action: { viewModel.triggerSimulatedBurstAnomaly() }) {
                    Text("Simulate Burst")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(16)
                }
            }

            if !viewModel.encryptedPayloadOutput.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.encryptedPayloadOutput)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(ObsidianTheme.secondaryIndigo)
                        .padding(8)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(8)

                    Text("Decrypted Output: \(viewModel.decryptedPayloadOutput)")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.tertiaryEmerald)
                }
            }
        }
        .padding(16)
        .obsidianGlassCard(cornerRadius: 22)
    }

    private var passkeyBiometricsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "touchid")
                    .foregroundColor(ObsidianTheme.primaryCyan)
                Text("Biometrics & Passkeys Suite")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                StatusBadge(text: "FIDO2", color: ObsidianTheme.primaryCyan)
            }

            // Toggle FaceID
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Apple FaceID / TouchID")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                    Text("Biometric verification for instant node auth")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.6))
                }
                Spacer()
                Toggle("", isOn: $viewModel.isFaceIDEnabled)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: ObsidianTheme.primaryCyan))
            }
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)

            // Passkey Credential Synced
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Passkey Credential Synced")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                    Text("iCloud Keychain · Active 2m ago")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(ObsidianTheme.tertiaryEmerald)
                }
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(ObsidianTheme.tertiaryEmerald)
            }
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)

            // Auto-Lock Timeout
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Session Auto-Lock Timeout")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.8))
                    Spacer()
                    Text(viewModel.sessionAutoLockTimeout)
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.primaryCyan)
                }

                HStack(spacing: 8) {
                    ForEach(["Immediate", "1 Min", "5 Mins"], id: \.self) { timeout in
                        Button(action: { viewModel.sessionAutoLockTimeout = timeout }) {
                            Text(timeout)
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(viewModel.sessionAutoLockTimeout == timeout ? .black : Color.white.opacity(0.7))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .background(viewModel.sessionAutoLockTimeout == timeout ? ObsidianTheme.primaryCyan : Color.white.opacity(0.08))
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
        .padding(16)
        .obsidianGlassCard(cornerRadius: 24)
    }

    private var privacyTelemetrySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lock.shield.fill")
                    .foregroundColor(ObsidianTheme.secondaryIndigo)
                Text("E2EE Privacy Telemetry")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
            }

            // Fingerprint Matrix
            VStack(alignment: .leading, spacing: 6) {
                Text("SESSION KEY FINGERPRINT MATRIX")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.white.opacity(0.5))

                HStack(spacing: 8) {
                    ForEach(viewModel.sessionFingerprintMatrix, id: \.self) { key in
                        Text(key)
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(ObsidianTheme.primaryCyan)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                    }
                }
            }

            // Tor Relay Toggle
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Tor / Onion Metadata Relay")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                    Text("Mask geographic & IP telemetry across peer nodes")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.6))
                }
                Spacer()
                Toggle("", isOn: $viewModel.isOnionRelayEnabled)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: ObsidianTheme.secondaryIndigo))
            }
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
        }
        .padding(16)
        .obsidianGlassCard(cornerRadius: 24)
    }

    private var familyGovernanceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.2.circle.fill")
                    .foregroundColor(ObsidianTheme.tertiaryEmerald)
                Text("Family Mesh & Governance")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Daily Micro-Mint Cap")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Text("$\(String(format: "%.2f", viewModel.dailyMicroMintSpentUSD)) / $\(String(format: "%.2f", viewModel.dailyMicroMintCapUSD))")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.tertiaryEmerald)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.white.opacity(0.1)).frame(height: 6)
                        Capsule().fill(ObsidianTheme.tertiaryEmerald).frame(width: geo.size.width * (viewModel.dailyMicroMintSpentUSD / viewModel.dailyMicroMintCapUSD), height: 6)
                    }
                }
                .frame(height: 6)
            }

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Require Guardian Approval for Passes")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                    Text("Curfew: \(viewModel.curfewHours)")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.6))
                }
                Spacer()
                Toggle("", isOn: $viewModel.isGuardianApprovalRequired)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: ObsidianTheme.tertiaryEmerald))
            }
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
        }
        .padding(16)
        .obsidianGlassCard(cornerRadius: 24)
    }

    private var emergencyLockdownSection: some View {
        VStack(spacing: 10) {
            Button(action: { viewModel.signOutMeshSession() }) {
                HStack(spacing: 6) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Sign Out of Mesh Session")
                }
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.08))
                .cornerRadius(16)
            }

            Button(action: { viewModel.emergencyFreezeAllShards() }) {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.shield.fill")
                    Text("Emergency Freeze All Shards & Keys")
                }
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.red.opacity(0.2))
                .cornerRadius(16)
            }
        }
    }
}
