//
//  HomeFeedView.swift
//  CosmosApp
//
//  Home Feed Screen (Spatial Cortex Summary, Segmented Picker, $L2E Vault HUD, AR Canvas Anchor Feed)
//

import SwiftUI

public struct HomeFeedView: View {
    @StateObject private var viewModel = HomeFeedViewModel()

    public init() {}

    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Header Bar
                headerView

                // Live Sync Status / Offline Fallback Banner
                syncStatusBanner

                if !viewModel.isSpatialFeedEnabled {
                    remoteDisabledBanner
                } else if viewModel.isMaintenanceModeActive {
                    maintenanceBanner
                } else {
                    // 1. Top Floating AI Executive Summary Pill
                    cortexSummaryPill

                    // 2. Segmented Mode Switcher (Spatial Map, Video Feed, Articles)
                    modeSwitcherPicker

                    // 3. Learn-to-Earn ($L2E) Token Counter & Live Progress HUD
                    vaultProgressCard

                    // 4. Feed Content Section
                    feedPostsSection
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .padding(.bottom, 100) // Clearance for floating bottom nav
        }
        .background(
            ZStack {
                ObsidianTheme.darkBackground.ignoresSafeArea()
                // Ambient Radial Glows
                Circle()
                    .fill(ObsidianTheme.secondaryIndigo.opacity(0.12))
                    .blur(radius: 100)
                    .frame(width: 300, height: 300)
                    .offset(x: -120, y: -200)

                Circle()
                    .fill(ObsidianTheme.primaryCyan.opacity(0.1))
                    .blur(radius: 90)
                    .frame(width: 280, height: 280)
                    .offset(x: 120, y: 100)
            }
        )
    }

    // MARK: - Subviews

    private var headerView: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: "circle.hexagonpath.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(ObsidianTheme.primaryCyan)
                    .shadow(color: ObsidianTheme.primaryCyan.opacity(0.6), radius: 8)

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text("Aether")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        HStack(spacing: 4) {
                            Circle()
                                .fill(ObsidianTheme.tertiaryEmerald)
                                .frame(width: 6, height: 6)
                                .shadow(color: ObsidianTheme.tertiaryEmerald, radius: 4)
                            Text("NODE 01")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(ObsidianTheme.tertiaryEmerald)
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)
                    }

                    Text("SPATIAL CANVAS FEED")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.5))
                }
            }

            Spacer()

            HStack(spacing: 10) {
                Button(action: {}) {
                    Image(systemName: "spatial.audio")
                        .font(.system(size: 16))
                        .foregroundColor(Color.white.opacity(0.8))
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Circle())
                }

                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(ObsidianTheme.primaryGlowGradient)
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .padding(2)
                        )

                    Circle()
                        .fill(ObsidianTheme.tertiaryEmerald)
                        .frame(width: 10, height: 10)
                        .overlay(Circle().stroke(Color.black, lineWidth: 1.5))
                }
            }
        }
    }

    private var syncStatusBanner: some View {
        Group {
            if viewModel.syncStatus != .synced {
                HStack(spacing: 8) {
                    Image(systemName: viewModel.syncStatus == .offline ? "wifi.slash" : "exclamationmark.triangle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.orange)

                    Text(viewModel.syncErrorMessage ?? viewModel.syncStatus.rawValue)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.white)

                    Spacer()

                    Button(action: { viewModel.retrySync() }) {
                        Text("Retry Sync")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(ObsidianTheme.primaryCyan)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(ObsidianTheme.primaryCyan.opacity(0.15))
                            .cornerRadius(10)
                    }
                }
                .padding(10)
                .background(Color.orange.opacity(0.15))
                .cornerRadius(14)
            }
        }
    }

    private var remoteDisabledBanner: some View {
        VStack(spacing: 14) {
            Image(systemName: "eye.slash.fill")
                .font(.system(size: 36))
                .foregroundColor(.orange)

            Text("Spatial Canvas Feed Temporarily Disabled")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)

            Text("Remote administrators have temporarily paused live feed streaming for protocol upgrades.")
                .font(.system(size: 12))
                .foregroundColor(Color.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .obsidianGlassCard()
    }

    private var maintenanceBanner: some View {
        VStack(spacing: 14) {
            Image(systemName: "wrench.and.screwdriver.fill")
                .font(.system(size: 36))
                .foregroundColor(ObsidianTheme.primaryCyan)

            Text("Network Maintenance in Progress")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)

            Text("Cosmos Spatial Network is under scheduled maintenance. Real-time sync will resume shortly.")
                .font(.system(size: 12))
                .foregroundColor(Color.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .obsidianGlassCard()
    }

    private var cortexSummaryPill: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(ObsidianTheme.surfaceContainer)
                        .frame(width: 32, height: 32)
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 16))
                        .foregroundColor(ObsidianTheme.primaryCyan)
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("SPATIAL CORTEX SYNCED")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(ObsidianTheme.primaryCyan)

                        Spacer()

                        Button(action: { viewModel.toggleSummary() }) {
                            Image(systemName: viewModel.isSummaryExpanded ? "chevron.up" : "chevron.down")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color.white.opacity(0.6))
                        }
                    }

                    Text("3 spatial nodes active near you · 14 voice waves · +45 $L2E today")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
            }

            if viewModel.isSummaryExpanded {
                VStack(spacing: 8) {
                    Divider().background(Color.white.opacity(0.1))

                    HStack {
                        HStack(spacing: 6) {
                            Circle().fill(ObsidianTheme.primaryCyan).frame(width: 6, height: 6)
                            Text("Shibuya Crossing Geo-Anchor")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                        Spacer()
                        Text("0.4 km")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(ObsidianTheme.primaryCyan)
                    }

                    HStack {
                        HStack(spacing: 6) {
                            Circle().fill(ObsidianTheme.secondaryIndigo).frame(width: 6, height: 6)
                            Text("Roppongi Resonance Lab")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                        Spacer()
                        Text("1.2 km")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(ObsidianTheme.primaryCyan)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(12)
        .obsidianGlassCard(cornerRadius: 20)
    }

    private var modeSwitcherPicker: some View {
        HStack(spacing: 6) {
            ForEach(FeedMode.allCases) { mode in
                Button(action: { viewModel.selectFeedMode(mode) }) {
                    HStack(spacing: 6) {
                        Image(systemName: mode.iconName)
                            .font(.system(size: 12))
                        Text(mode.rawValue)
                            .font(.system(size: 12, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        viewModel.selectedFeedMode == mode
                        ? ObsidianTheme.primaryGlowGradient
                        : LinearGradient(colors: [Color.white.opacity(0.04)], startPoint: .leading, endPoint: .trailing)
                    )
                    .foregroundColor(viewModel.selectedFeedMode == mode ? .black : Color.white.opacity(0.7))
                    .cornerRadius(20)
                    .shadow(color: viewModel.selectedFeedMode == mode ? ObsidianTheme.primaryCyan.opacity(0.3) : .clear, radius: 8)
                }
            }
        }
        .padding(4)
        .background(Color.black.opacity(0.3))
        .cornerRadius(24)
    }

    private var vaultProgressCard: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(ObsidianTheme.tertiaryEmerald.opacity(0.2))
                            .frame(width: 36, height: 36)
                        Image(systemName: "bolt.ring.closed")
                            .font(.system(size: 18))
                            .foregroundColor(ObsidianTheme.tertiaryEmerald)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("VAULT BALANCE")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(Color.white.opacity(0.6))
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(String(format: "%.2f", viewModel.vaultBalanceL2E))
                                .font(.system(size: 22, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                            Text("$L2E")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(ObsidianTheme.tertiaryEmerald)
                        }
                    }
                }

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 12))
                    Text(String(format: "+%.1f/hr", viewModel.hourlyL2ERate))
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                }
                .foregroundColor(ObsidianTheme.tertiaryEmerald)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(ObsidianTheme.tertiaryEmerald.opacity(0.15))
                .cornerRadius(16)
            }

            VStack(spacing: 6) {
                HStack {
                    Text("Daily Quest: Listen to 3 Voice Anchors")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.8))
                    Spacer()
                    Text("\(viewModel.dailyQuestCompleted) / \(viewModel.dailyQuestTotal)")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.primaryCyan)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 6)
                        Capsule()
                            .fill(ObsidianTheme.primaryGlowGradient)
                            .frame(width: geo.size.width * (Double(viewModel.dailyQuestCompleted) / Double(viewModel.dailyQuestTotal)), height: 6)
                            .shadow(color: ObsidianTheme.primaryCyan.opacity(0.5), radius: 4)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(14)
        .obsidianGlassCard(cornerRadius: 24)
    }

    private var feedPostsSection: some View {
        VStack(spacing: 16) {
            // Card A: 3D AR Spatial Map Post
            spatialCanvasCard

            // Card B: Video & Deep Dive Hybrid Article Post
            videoArticleHybridCard
        }
    }

    private var spatialCanvasCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Author Bar
            HStack {
                HStack(spacing: 10) {
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .fill(ObsidianTheme.secondaryIndigo)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                            )
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 12))
                            .foregroundColor(ObsidianTheme.primaryCyan)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 4) {
                            Text("Kira Vance")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                            Text("@kira.spatial")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundColor(Color.white.opacity(0.5))
                        }
                        HStack(spacing: 4) {
                            Text("24m ago ·")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(Color.white.opacity(0.5))
                            Text("AR Neo Tokyo Anchor")
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .foregroundColor(ObsidianTheme.secondaryIndigo)
                        }
                    }
                }

                Spacer()

                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Color.white.opacity(0.6))
                }
            }

            // 3D Holographic Spatial Radar Viewport
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.6))
                    .frame(height: 180)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(ObsidianTheme.primaryCyan.opacity(0.3), lineWidth: 1)
                    )

                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .stroke(ObsidianTheme.primaryCyan.opacity(0.4), lineWidth: 1)
                            .frame(width: 100, height: 100)

                        Circle()
                            .stroke(ObsidianTheme.secondaryIndigo.opacity(0.5), lineWidth: 1)
                            .frame(width: 60, height: 60)

                        Circle()
                            .fill(ObsidianTheme.primaryCyan)
                            .frame(width: 12, height: 12)
                            .shadow(color: ObsidianTheme.primaryCyan, radius: 10)
                    }

                    Text("SHIBUYA AUDIO HEX 04")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.primaryCyan)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(12)
                }

                VStack {
                    HStack {
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "sensor.tag.radiowaves.forward.fill")
                                .font(.system(size: 10))
                            Text("SPATIAL LIVE")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                        }
                        .foregroundColor(ObsidianTheme.tertiaryEmerald)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(12)
                    }
                    Spacer()
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 10))
                            Text("12.8m Elevation · 96kHz")
                                .font(.system(size: 9, design: .monospaced))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(12)
                        Spacer()
                    }
                }
                .padding(10)
            }

            // Title & Description
            VStack(alignment: .leading, spacing: 4) {
                Text("Echoes of Shibuya: Acoustic Architecture in Mixed Reality")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                Text("Mapping sound reflections against neo-brutalist glass facades. Stand precisely at the crossing node to experience spatial binaural time-reversal.")
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.7))
            }

            // Donation Bar
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Acoustic Preservation Fund")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                    Text("Raised today: $\(String(format: "%.2f", viewModel.donationFundRaisedToday))")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(ObsidianTheme.tertiaryEmerald)
                }

                Spacer()

                Button(action: { viewModel.donateToFund() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 10))
                        Text("Donate $0.50")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(ObsidianTheme.emeraldGlowGradient)
                    .cornerRadius(16)
                    .shadow(color: ObsidianTheme.tertiaryEmerald.opacity(0.4), radius: 6)
                }
            }
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(14)

            // Soundwave Voice Comment Box
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(ObsidianTheme.primaryCyan)
                        Text("@mika_audio")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Text("Binaural 3D")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.primaryCyan)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(ObsidianTheme.primaryCyan.opacity(0.15))
                        .cornerRadius(8)
                }

                HStack(spacing: 10) {
                    Button(action: { viewModel.toggleVoiceNotePlayback() }) {
                        Image(systemName: viewModel.isVoiceNotePlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .frame(width: 32, height: 32)
                            .background(ObsidianTheme.primaryCyan)
                            .clipShape(Circle())
                            .shadow(color: ObsidianTheme.primaryCyan.opacity(0.5), radius: 6)
                    }

                    // Simulated Frequency Waveform Bars
                    HStack(spacing: 3) {
                        ForEach(0..<18, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(index < (viewModel.voiceNoteCurrentSeconds / 2) ? ObsidianTheme.primaryCyan : Color.white.opacity(0.2))
                                .frame(width: 3, height: CGFloat([12, 18, 26, 14, 22, 28, 16, 20, 24, 10, 18, 25, 15, 20, 12, 19, 22, 14][index]))
                        }
                    }

                    Spacer()

                    Text("0:\(String(format: "%02d", viewModel.voiceNoteCurrentSeconds)) / 0:38")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.6))
                }

                Text("“The reverberation model at the crossing feels astonishingly real, especially near Hachiko square…”")
                    .font(.system(size: 11, weight: .regular))
                    .italic()
                    .foregroundColor(Color.white.opacity(0.7))
            }
            .padding(10)
            .background(Color.white.opacity(0.04))
            .cornerRadius(14)
        }
        .padding(16)
        .obsidianGlassCard(cornerRadius: 28)
    }

    private var videoArticleHybridCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("DEEP DIVE")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(ObsidianTheme.secondaryIndigo)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(ObsidianTheme.secondaryIndigo.opacity(0.2))
                    .cornerRadius(10)

                Spacer()

                Button(action: { viewModel.tipCreatorL2E() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle.fill")
                        Text("Earn 15 $L2E")
                    }
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(ObsidianTheme.tertiaryEmerald)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("The Decentralized Spatial Web: Nodes, Audio Anchors & Ownership")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)

                Text("Why decentralized acoustic metadata will replace flat web navigation across the next computing cycle.")
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.7))
            }

            HStack {
                Button(action: { viewModel.tipCreatorL2E() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "waveform")
                        Text("Echo (\(viewModel.echoCount))")
                    }
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.8))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(16)
                }

                Button(action: { viewModel.toggleResonate() }) {
                    HStack(spacing: 4) {
                        Image(systemName: viewModel.isResonated ? "heart.fill" : "heart")
                        Text(viewModel.isResonated ? "Resonated" : "Resonate")
                    }
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(viewModel.isResonated ? ObsidianTheme.primaryCyan : Color.white.opacity(0.8))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(16)
                }

                Spacer()

                Button(action: { viewModel.tipCreatorL2E() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "gift.fill")
                        Text("Tip $L2E")
                    }
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(ObsidianTheme.tertiaryEmerald)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(ObsidianTheme.tertiaryEmerald.opacity(0.15))
                    .cornerRadius(16)
                }
            }
        }
        .padding(16)
        .obsidianGlassCard(cornerRadius: 24)
    }
}
