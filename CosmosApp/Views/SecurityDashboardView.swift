//
//  SecurityDashboardView.swift
//  CosmosApp
//
//  View for 4-Layer Security Shield Dashboard
//

import SwiftUI

public struct SecurityDashboardView: View {
    @StateObject private var viewModel = SecurityDashboardViewModel()

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("4-LAYER SECURITY SHIELD")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(ObsidianTheme.primaryCyan)
                        Text("System Protection")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    StatusBadge(
                        text: viewModel.rootSecurityStatus?.isSecure == true ? "SYSTEM SECURE" : "THREAT ALERT",
                        color: viewModel.rootSecurityStatus?.isSecure == true ? ObsidianTheme.tertiaryEmerald : Color.red
                    )
                }
                .padding(.top, 10)

                // Layer 1: Boundary - App Check
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "shield.checkmark.fill")
                            .foregroundColor(ObsidianTheme.primaryCyan)
                        Text("Layer 1: Boundary (Firebase App Check)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        StatusBadge(
                            text: viewModel.isAppCheckValid ? "ATTESTED" : "UNVERIFIED",
                            color: viewModel.isAppCheckValid ? ObsidianTheme.tertiaryEmerald : Color.orange
                        )
                    }

                    Text("App Attest / DeviceCheck Attestation Token:")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.6))

                    Text(viewModel.appCheckToken)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(ObsidianTheme.primaryCyan)
                        .lineLimit(2)
                        .padding(10)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(8)
                }
                .padding(16)
                .obsidianGlassCard()

                // Layer 2: Cryptography - AES-256 E2EE
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "lock.square.stack.fill")
                            .foregroundColor(ObsidianTheme.primaryCyan)
                        Text("Layer 2: Cryptography (CryptoKit AES-256 E2EE)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    }

                    TextField("Text to encrypt...", text: $viewModel.testPayloadInput)
                        .padding(10)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(8)
                        .foregroundColor(.white)

                    HStack {
                        GlowButton(title: "Encrypt & Test E2EE", iconName: "lock.fill") {
                            viewModel.testE2EEEncryption()
                        }
                    }

                    if !viewModel.encryptedPayloadOutput.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Sealed Box Output:")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(Color.white.opacity(0.6))
                            Text(viewModel.encryptedPayloadOutput)
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(ObsidianTheme.secondaryIndigo)
                                .padding(8)
                                .background(Color.black.opacity(0.4))
                                .cornerRadius(6)

                            Text("Decrypted Result: \(viewModel.decryptedPayloadOutput)")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(ObsidianTheme.tertiaryEmerald)
                                .padding(.top, 4)
                        }
                    }
                }
                .padding(16)
                .obsidianGlassCard()

                // Layer 3: AI Surveillance & Security Rules
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "eye.trianglebadge.exclamationmark.fill")
                            .foregroundColor(ObsidianTheme.primaryCyan)
                        Text("Layer 3: AI Surveillance & Firestore Rules")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        GlowButton(title: "Simulate Burst", isAccent: false) {
                            viewModel.triggerSimulatedBurstAnomaly()
                        }
                    }

                    Text("Security Audit Log (\(viewModel.recentSecurityEvents.count) Events)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.white.opacity(0.7))

                    if viewModel.recentSecurityEvents.isEmpty {
                        Text("No active anomalies detected.")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(Color.white.opacity(0.5))
                    } else {
                        ForEach(viewModel.recentSecurityEvents.prefix(3)) { event in
                            HStack {
                                StatusBadge(text: event.severity.rawValue, color: event.severity == .critical || event.severity == .high ? .red : .orange)
                                Text(event.details)
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                            }
                            .padding(8)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(6)
                        }
                    }
                }
                .padding(16)
                .obsidianGlassCard()

                // Layer 4: Root Protection
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "cpu.fill")
                            .foregroundColor(ObsidianTheme.primaryCyan)
                        Text("Layer 4: Root Protection & SSL Pinning")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    }

                    if let rootStatus = viewModel.rootSecurityStatus {
                        HStack(spacing: 12) {
                            StatusBadge(text: rootStatus.isJailbroken ? "JAILBROKEN" : "NO JAILBREAK", color: rootStatus.isJailbroken ? .red : ObsidianTheme.tertiaryEmerald)
                            StatusBadge(text: rootStatus.isDebuggerAttached ? "DEBUGGER DETECTED" : "NO DEBUGGER", color: rootStatus.isDebuggerAttached ? .red : ObsidianTheme.tertiaryEmerald)
                            StatusBadge(text: rootStatus.isDyldInjected ? "DYLD INJECTED" : "NO INJECTION", color: rootStatus.isDyldInjected ? .red : ObsidianTheme.tertiaryEmerald)
                        }
                    }
                }
                .padding(16)
                .obsidianGlassCard()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
        }
        .background(ObsidianTheme.darkBackground.ignoresSafeArea())
    }
}
