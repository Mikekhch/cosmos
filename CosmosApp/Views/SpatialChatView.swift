//
//  SpatialChatView.swift
//  CosmosApp
//
//  Spatial Chat & Messenger View (Binaural Call Telemetry, AR Holographic Viewport, Sentiment Stream, VIP Ticket Drop, E2EE Input Dock)
//

import SwiftUI

public struct SpatialChatView: View {
    @StateObject private var viewModel = SpatialChatViewModel()

    public init() {}

    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                // 1. Spatial Call Telemetry Header
                callTelemetryHeader

                if !viewModel.isE2EESpatialChatEnabled {
                    disabledChatCard
                } else {
                    // 2. Spatial Holographic Telemetry Viewport
                    spatialHolographicViewport

                    // 3. Co-Watch Stage Card
                    coWatchStageCard

                    // 4. Sentiment Stream & In-Chat VIP Drop
                    sentimentStreamSection

                    // 5. E2EE Input Bar Dock
                    e2eeInputDock
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .padding(.bottom, 100)
        }
        .background(
            ZStack {
                ObsidianTheme.darkBackground.ignoresSafeArea()
                Circle()
                    .fill(ObsidianTheme.primaryCyan.opacity(0.12))
                    .blur(radius: 100)
                    .frame(width: 300, height: 300)
                    .offset(x: 100, y: -150)
            }
        )
    }

    // MARK: - Subviews

    private var disabledChatCard: some View {
        VStack(spacing: 14) {
            Image(systemName: "lock.slash.fill")
                .font(.system(size: 36))
                .foregroundColor(.orange)

            Text("Spatial Chat Stream Paused")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)

            Text("E2EE Messenger module is temporarily offline via Enterprise Remote Config.")
                .font(.system(size: 12))
                .foregroundColor(Color.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .obsidianGlassCard()
    }

    private var callTelemetryHeader: some View {
        VStack(spacing: 10) {
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(ObsidianTheme.primaryCyan)
                        .frame(width: 8, height: 8)
                        .shadow(color: ObsidianTheme.primaryCyan, radius: 6)

                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 4) {
                            Text("Binaural Call")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                            Text("· \(viewModel.connectedPeersCount) Connected")
                                .font(.system(size: 11))
                                .foregroundColor(Color.white.opacity(0.7))
                        }

                        HStack(spacing: 6) {
                            Text("ENC-P2P")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .foregroundColor(ObsidianTheme.tertiaryEmerald)
                            Text("· \(viewModel.latencyMs)ms Latency · 360° Positional")
                                .font(.system(size: 9, design: .monospaced))
                                .foregroundColor(ObsidianTheme.primaryCyan)
                        }
                    }
                }

                Spacer()

                HStack(spacing: 8) {
                    Button(action: { viewModel.toggleMic() }) {
                        Image(systemName: viewModel.isMicMuted ? "mic.slash.fill" : "mic.fill")
                            .font(.system(size: 13))
                            .foregroundColor(viewModel.isMicMuted ? .red : .white)
                            .frame(width: 32, height: 32)
                            .background(viewModel.isMicMuted ? Color.red.opacity(0.2) : Color.white.opacity(0.08))
                            .clipShape(Circle())
                    }

                    Button(action: { viewModel.toggleSpatialAudio() }) {
                        Image(systemName: "spatial.tracking")
                            .font(.system(size: 13))
                            .foregroundColor(viewModel.isSpatialAudio3DActive ? ObsidianTheme.primaryCyan : .white)
                            .frame(width: 32, height: 32)
                            .background(viewModel.isSpatialAudio3DActive ? ObsidianTheme.primaryCyan.opacity(0.2) : Color.white.opacity(0.08))
                            .clipShape(Circle())
                    }

                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "phone.down.fill")
                                .font(.system(size: 11))
                            Text("Leave")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                        }
                        .foregroundColor(.red)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(16)
                    }
                }
            }

            // Sub-Mode Tabs
            HStack(spacing: 4) {
                ForEach(["HUD Call (Live)", "Chat Stream (4)", "Co-Watch (1)"], id: \.self) { tab in
                    Button(action: { viewModel.selectedCallTab = tab }) {
                        Text(tab)
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(viewModel.selectedCallTab == tab ? ObsidianTheme.primaryCyan : Color.white.opacity(0.6))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            .background(viewModel.selectedCallTab == tab ? Color.white.opacity(0.1) : Color.clear)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(2)
            .background(Color.black.opacity(0.3))
            .cornerRadius(14)
        }
        .padding(12)
        .obsidianGlassCard(cornerRadius: 20)
    }

    private var spatialHolographicViewport: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.black.opacity(0.85))
                .frame(height: 220)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(ObsidianTheme.primaryCyan.opacity(0.3), lineWidth: 1)
                )

            // AR Holographic Visual
            VStack(spacing: 8) {
                Image(systemName: "sparkles.tv.fill")
                    .font(.system(size: 48))
                    .foregroundColor(ObsidianTheme.primaryCyan)
                    .shadow(color: ObsidianTheme.primaryCyan, radius: 10)

                Text("NEO-SHIBUYA // 04")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(ObsidianTheme.tertiaryEmerald)
            }

            VStack {
                HStack {
                    Text("AI-HOLOLINK STABLE")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.tertiaryEmerald)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(10)

                    Spacer()

                    StatusBadge(text: "AES-256 E2EE", color: ObsidianTheme.tertiaryEmerald)
                }

                Spacer()

                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(["Dr. Thorne (AI)", "Cyber-Knit", "Specter Neon", "Wireframe"], id: \.self) { persona in
                                Button(action: { viewModel.activePersona = persona }) {
                                    HStack(spacing: 4) {
                                        Circle().fill(viewModel.activePersona == persona ? ObsidianTheme.primaryCyan : Color.white.opacity(0.4)).frame(width: 6, height: 6)
                                        Text(persona)
                                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    }
                                    .foregroundColor(viewModel.activePersona == persona ? .black : .white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(viewModel.activePersona == persona ? ObsidianTheme.primaryCyan : Color.black.opacity(0.6))
                                    .cornerRadius(12)
                                }
                            }
                        }
                    }
                }
            }
            .padding(12)
        }
    }

    private var coWatchStageCard: some View {
        HStack {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(ObsidianTheme.secondaryIndigo.opacity(0.3))
                        .frame(width: 36, height: 36)
                    Image(systemName: "tv.fill")
                        .foregroundColor(ObsidianTheme.secondaryIndigo)
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text("Neo-Shibuya Runway 2049")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                        StatusBadge(text: "LIVE SYNC", color: ObsidianTheme.tertiaryEmerald)
                    }
                    Text("Host: Kira Vance · 3 in Stage (0.02s delta)")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.6))
                }
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "display")
                    .foregroundColor(ObsidianTheme.primaryCyan)
                    .frame(width: 32, height: 32)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
            }
        }
        .padding(12)
        .obsidianGlassCard(cornerRadius: 18)
    }

    private var sentimentStreamSection: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .foregroundColor(ObsidianTheme.primaryCyan)
                    Text("Spatial Sentiment Stream")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.6))
                }

                Spacer()

                Text("Atmosphere: Euphoric")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(ObsidianTheme.tertiaryEmerald)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(ObsidianTheme.tertiaryEmerald.opacity(0.15))
                    .cornerRadius(10)
            }

            // Message 1: Excited
            if let msg1 = viewModel.sentimentMessages.first(where: { $0.id == "1" }) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(ObsidianTheme.primaryCyan)
                            Text(msg1.authorName)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(ObsidianTheme.primaryCyan)
                            Text(msg1.timeString)
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(Color.white.opacity(0.5))
                        }
                        Spacer()
                        StatusBadge(text: msg1.sentimentTag, color: msg1.sentimentColor)
                    }

                    Text(msg1.textContent)
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
                .padding(12)
                .obsidianGlassCard(cornerRadius: 18)
            }

            // In-Chat Drop: VIP Ticket Drop Card
            vipTicketDropCard

            // Message 2 & 3
            ForEach(viewModel.sentimentMessages.filter { $0.id != "1" }) { msg in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: msg.isVoiceNote ? "waveform.circle.fill" : "person.circle.fill")
                                .foregroundColor(msg.sentimentColor)
                            Text(msg.authorName)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(msg.sentimentColor)
                            Text(msg.timeString)
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(Color.white.opacity(0.5))
                        }
                        Spacer()
                        StatusBadge(text: msg.sentimentTag, color: msg.sentimentColor)
                    }

                    if msg.isVoiceNote {
                        // Voice Note Player
                        HStack(spacing: 10) {
                            Button(action: { viewModel.toggleVoicePlay() }) {
                                Image(systemName: viewModel.isVoicePlaying ? "pause.fill" : "play.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                                    .frame(width: 32, height: 32)
                                    .background(ObsidianTheme.tertiaryEmerald)
                                    .clipShape(Circle())
                            }

                            HStack(spacing: 3) {
                                ForEach(0..<14, id: \.self) { idx in
                                    Rectangle()
                                        .fill(idx < (viewModel.voiceSeconds / 2) ? ObsidianTheme.tertiaryEmerald : Color.white.opacity(0.2))
                                        .frame(width: 3, height: CGFloat([10, 16, 22, 12, 18, 10, 20, 14, 18, 10, 12, 8, 15, 10][idx]))
                                }
                            }

                            Spacer()

                            Text("0:\(String(format: "%02d", viewModel.voiceSeconds)) / 0:\(msg.voiceDurationSeconds ?? 24)")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(Color.white.opacity(0.6))
                        }
                        .padding(8)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                    }

                    Text(msg.textContent)
                        .font(.system(size: 12))
                        .foregroundColor(.white)

                    // Reactions
                    HStack(spacing: 6) {
                        ForEach(Array(msg.reactions.keys), id: \.self) { emoji in
                            Button(action: { viewModel.addReaction(messageId: msg.id, emoji: emoji) }) {
                                HStack(spacing: 2) {
                                    Text(emoji)
                                    Text("\(msg.reactions[emoji] ?? 1)")
                                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.08))
                                .cornerRadius(12)
                            }
                        }
                    }
                }
                .padding(12)
                .obsidianGlassCard(cornerRadius: 18)
            }
        }
    }

    private var vipTicketDropCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(ObsidianTheme.primaryGlowGradient)
                            .frame(width: 32, height: 32)
                        Image(systemName: "ticket.fill")
                            .foregroundColor(.black)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Neo-Tokyo Runway Pass")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        Text("Tier 1 · Backstage Holo-Access")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(ObsidianTheme.tertiaryEmerald)
                    }
                }

                Spacer()

                Text("\(viewModel.ticketsRemaining) Left")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.red)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(10)
            }

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("PRICE")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.5))
                    Text("$85.00 or 45 $L2E")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.primaryCyan)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("VAULT BALANCE")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.5))
                    Text("1,420.50 $L2E")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.tertiaryEmerald)
                }
            }
            .padding(10)
            .background(Color.black.opacity(0.4))
            .cornerRadius(12)

            HStack(spacing: 10) {
                GlowButton(title: viewModel.userHasMintedPass ? "Pass Minted!" : "Instant Mint Pass", iconName: "bolt.fill") {
                    viewModel.mintPass()
                }

                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "gift.fill")
                        Text("Gift")
                    }
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(16)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(ObsidianTheme.surfaceContainer.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(ObsidianTheme.primaryCyan, lineWidth: 1)
                )
                .shadow(color: ObsidianTheme.primaryCyan.opacity(0.3), radius: 10)
        )
    }

    private var e2eeInputDock: some View {
        HStack(spacing: 8) {
            Button(action: {}) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(ObsidianTheme.primaryCyan)
            }

            TextField("Message spatial room or hold mic...", text: $viewModel.messageInput)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
                .foregroundColor(.white)

            Button(action: { viewModel.toggleMic() }) {
                Image(systemName: "mic.fill")
                    .font(.system(size: 16))
                    .foregroundColor(viewModel.isMicMuted ? .red : ObsidianTheme.tertiaryEmerald)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
            }

            GlowButton(title: "Send", iconName: "paperplane.fill") {
                viewModel.sendEncryptedMessage()
            }
        }
        .padding(8)
        .obsidianGlassCard(cornerRadius: 24)
    }
}
