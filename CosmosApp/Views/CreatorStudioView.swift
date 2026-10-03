//
//  CreatorStudioView.swift
//  CosmosApp
//
//  Creator Studio & Marketplace View (On-Demand Dynamic Module, High-Tech Viewport, Spatial Timeline & Multi-Warehouse Tagging)
//

import SwiftUI

public struct CreatorStudioView: View {
    @StateObject private var viewModel = CreatorStudioViewModel()

    public init() {}

    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                // Header & Project Bar
                studioHeaderBar

                if viewModel.isModuleMounted {
                    // Quick Aspect Ratio Selector & Overlay Toggles
                    aspectRatioSelectorBar

                    // High-Tech Video Editing Viewport
                    videoEditingViewport

                    // AI Neural Studio Action Deck
                    neuralToolsDeck

                    // Multi-Track Spatial Timeline Scrubber
                    spatialTimelineScrubber

                    // Live Multi-Warehouse Stock Tagging Drawer
                    inventoryTaggingDrawer
                } else {
                    // On-Demand Dynamic Module Mount Card
                    onDemandMountCard
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
                    .fill(ObsidianTheme.primaryCyan.opacity(0.1))
                    .blur(radius: 100)
                    .frame(width: 300, height: 300)
                    .offset(x: -100, y: -150)
            }
        )
        .onAppear {
            viewModel.checkModuleStatus()
        }
    }

    // MARK: - Subviews

    private var studioHeaderBar: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text("STUDIO")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(Color.white.opacity(0.5))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(Color.white.opacity(0.3))
                        Text("REELS ENGINE")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(ObsidianTheme.primaryCyan)
                    }

                    Text("Drop #04: Cyber-Knit Hologram")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }

                Spacer()

                StatusBadge(
                    text: viewModel.isModuleMounted ? "LIVE SYNC" : "ON-DEMAND",
                    color: viewModel.isModuleMounted ? ObsidianTheme.tertiaryEmerald : .orange
                )

                Button(action: { viewModel.exportVideo() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 12, weight: .bold))
                        Text("Export")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(ObsidianTheme.primaryGlowGradient)
                    .cornerRadius(20)
                    .shadow(color: ObsidianTheme.primaryCyan.opacity(0.4), radius: 8)
                }
            }
        }
        .padding(14)
        .obsidianGlassCard(cornerRadius: 20)
    }

    private var aspectRatioSelectorBar: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["9:16", "16:9", "1:1", "4:5"], id: \.self) { ratio in
                        Button(action: { viewModel.selectedAspectRatio = ratio }) {
                            HStack(spacing: 4) {
                                Image(systemName: ratio == "9:16" ? "crop.portrait" : "crop.16.9")
                                    .font(.system(size: 11))
                                Text(ratio)
                                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                            }
                            .foregroundColor(viewModel.selectedAspectRatio == ratio ? ObsidianTheme.primaryCyan : Color.white.opacity(0.6))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                viewModel.selectedAspectRatio == ratio
                                ? ObsidianTheme.primaryCyan.opacity(0.2)
                                : Color.white.opacity(0.06)
                            )
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(viewModel.selectedAspectRatio == ratio ? ObsidianTheme.primaryCyan : Color.clear, lineWidth: 1)
                            )
                        }
                    }
                }
            }

            HStack(spacing: 6) {
                Button(action: { viewModel.isGridOverlayActive.toggle() }) {
                    Image(systemName: "grid")
                        .font(.system(size: 13))
                        .foregroundColor(viewModel.isGridOverlayActive ? ObsidianTheme.primaryCyan : Color.white.opacity(0.5))
                        .padding(8)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Circle())
                }

                Button(action: { viewModel.isSafeZoneActive.toggle() }) {
                    Image(systemName: "viewfinder")
                        .font(.system(size: 13))
                        .foregroundColor(viewModel.isSafeZoneActive ? ObsidianTheme.primaryCyan : Color.white.opacity(0.5))
                        .padding(8)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Circle())
                }
            }
        }
    }

    private var videoEditingViewport: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.black.opacity(0.85))
                .frame(height: 280)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(ObsidianTheme.primaryCyan.opacity(0.3), lineWidth: 1)
                )

            // Rule-of-Thirds Grid Overlay
            if viewModel.isGridOverlayActive {
                VStack {
                    Spacer()
                    Divider().background(ObsidianTheme.primaryCyan.opacity(0.2))
                    Spacer()
                    Divider().background(ObsidianTheme.primaryCyan.opacity(0.2))
                    Spacer()
                }
            }

            // Central Holographic AR Model Simulation
            VStack(spacing: 8) {
                Image(systemName: "tshirt.fill")
                    .font(.system(size: 54))
                    .foregroundColor(ObsidianTheme.primaryCyan)
                    .shadow(color: ObsidianTheme.primaryCyan, radius: 12)

                Text("Filter: \(viewModel.activeFilter)")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(ObsidianTheme.secondaryIndigo)
            }

            // Floating AR Product Pin HUD
            VStack {
                HStack {
                    HStack(spacing: 6) {
                        Circle().fill(Color.red).frame(width: 6, height: 6)
                        Text("REC")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                        Text("00:14.21 / 00:45.00")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(ObsidianTheme.primaryCyan)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(12)

                    Spacer()

                    HStack(spacing: 4) {
                        Text("4K 60FPS HDR")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundColor(ObsidianTheme.tertiaryEmerald)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(12)
                }

                Spacer()

                HStack {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(ObsidianTheme.primaryCyan)
                            .frame(width: 8, height: 8)
                            .shadow(color: ObsidianTheme.primaryCyan, radius: 6)

                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text("Cyber-Knit 2049")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                Text("142 IN STOCK")
                                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                                    .foregroundColor(ObsidianTheme.tertiaryEmerald)
                            }
                            Text("$180.00 · 95 $L2E")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(ObsidianTheme.secondaryIndigo)
                        }
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(ObsidianTheme.primaryCyan.opacity(0.4), lineWidth: 1)
                    )

                    Spacer()

                    Button(action: { viewModel.captureVideoFrame() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "wand.and.stars")
                            Text("Enhance")
                        }
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(ObsidianTheme.primaryCyan)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(14)
                    }
                }
            }
            .padding(12)
        }
    }

    private var neuralToolsDeck: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "brain.fill")
                        .foregroundColor(ObsidianTheme.primaryCyan)
                    Text("Neural Studio Tools")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                Text("v3.2 Latent Engine")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(ObsidianTheme.tertiaryEmerald)
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                // Tool 1: Auto-Captions
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Auto-Captions")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                        Text("98.4% Neo-Bilingual")
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundColor(ObsidianTheme.primaryCyan)
                    }
                    Spacer()
                    Toggle("", isOn: $viewModel.isAutoCaptionsEnabled)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: ObsidianTheme.primaryCyan))
                }
                .padding(10)
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)

                // Tool 2: BG Matte
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("BG Matte Neural")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                        Text("Alpha Glass Matte")
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundColor(ObsidianTheme.secondaryIndigo)
                    }
                    Spacer()
                    Toggle("", isOn: $viewModel.isBGMatteNeuralEnabled)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: ObsidianTheme.secondaryIndigo))
                }
                .padding(10)
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)

                // Tool 3: Spatial 3D Voice
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Spatial 3D Voice")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                        Text("Binaural Studio")
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundColor(ObsidianTheme.tertiaryEmerald)
                    }
                    Spacer()
                    Toggle("", isOn: $viewModel.isSpatialVoice3DEnabled)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: ObsidianTheme.tertiaryEmerald))
                }
                .padding(10)
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)

                // Tool 4: Auto Hotspots
                Button(action: { viewModel.captureVideoFrame() }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Auto Hotspots")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(ObsidianTheme.primaryCyan)
                            Text("Scan 3D Mesh")
                                .font(.system(size: 9, design: .monospaced))
                                .foregroundColor(Color.white.opacity(0.6))
                        }
                        Spacer()
                        Image(systemName: "radar")
                            .foregroundColor(ObsidianTheme.primaryCyan)
                    }
                    .padding(10)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
                }
            }
        }
        .padding(14)
        .obsidianGlassCard(cornerRadius: 22)
    }

    private var spatialTimelineScrubber: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "timeline.selection")
                        .foregroundColor(ObsidianTheme.secondaryIndigo)
                    Text("Spatial Timeline")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                Text("00:14.21")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(ObsidianTheme.primaryCyan)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(10)
            }

            VStack(spacing: 6) {
                // Video Track V1
                HStack {
                    Text("V1")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.primaryCyan)
                        .frame(width: 20)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(ObsidianTheme.primaryGlowGradient.opacity(0.4))
                        .frame(height: 24)
                        .overlay(
                            HStack {
                                Text("Cybernetic Runway Active")
                                    .font(.system(size: 9, design: .monospaced))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal, 8)
                        )
                }

                // Audio Track A1
                HStack {
                    Text("A1")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.secondaryIndigo)
                        .frame(width: 20)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(ObsidianTheme.secondaryIndigo.opacity(0.4))
                        .frame(height: 20)
                        .overlay(
                            HStack(spacing: 2) {
                                ForEach(0..<25, id: \.self) { _ in
                                    Rectangle().fill(ObsidianTheme.primaryCyan).frame(width: 2, height: CGFloat.random(in: 4...14))
                                }
                            }
                        )
                }

                // Tags Track
                HStack {
                    Text("Tags")
                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.tertiaryEmerald)
                        .frame(width: 20)

                    HStack {
                        StatusBadge(text: "CYB-2049 @ 00:14s", color: ObsidianTheme.tertiaryEmerald)
                        Spacer()
                    }
                }
            }
            .padding(8)
            .background(Color.black.opacity(0.4))
            .cornerRadius(12)

            // Transport Controls
            HStack {
                Spacer()

                Button(action: { viewModel.togglePlayPause() }) {
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 44, height: 44)
                        .background(ObsidianTheme.primaryGlowGradient)
                        .clipShape(Circle())
                        .shadow(color: ObsidianTheme.primaryCyan.opacity(0.5), radius: 10)
                }

                Spacer()
            }
        }
        .padding(14)
        .obsidianGlassCard(cornerRadius: 22)
    }

    private var inventoryTaggingDrawer: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "shippingbox.fill")
                        .foregroundColor(ObsidianTheme.primaryCyan)
                    Text("Live Stock Tagging")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                StatusBadge(text: "3 HUBS SYNCED", color: ObsidianTheme.tertiaryEmerald)
            }

            // Warehouse chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["Tokyo Mega-Hub (WH-01)", "Berlin Grid (WH-02)", "LA West Grid (WH-03)"], id: \.self) { hub in
                        Button(action: { viewModel.selectedWarehouse = hub }) {
                            Text(hub)
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(viewModel.selectedWarehouse == hub ? .black : Color.white.opacity(0.7))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(viewModel.selectedWarehouse == hub ? ObsidianTheme.primaryCyan : Color.white.opacity(0.08))
                                .cornerRadius(14)
                        }
                    }
                }
            }

            // Inventory Item Cards
            ForEach(viewModel.inventoryItems) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text(item.title)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                            Text(item.sku)
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(ObsidianTheme.primaryCyan)
                        }

                        Text("Stock: \(item.stockCount) units · $\(String(format: "%.2f", item.priceUSD)) / \(Int(item.priceL2E)) $L2E")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(Color.white.opacity(0.6))
                    }

                    Spacer()

                    if item.isTagged {
                        StatusBadge(text: "TAGGED @ 00:14s", color: ObsidianTheme.tertiaryEmerald)
                    } else {
                        GlowButton(title: "Tag to Video", iconName: "plus.circle") {
                            viewModel.tagItemToVideo(id: item.id)
                        }
                    }
                }
                .padding(10)
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
            }
        }
        .padding(14)
        .obsidianGlassCard(cornerRadius: 22)
    }

    private var onDemandMountCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 40))
                .foregroundColor(ObsidianTheme.primaryCyan)

            Text("Creator Studio assets (45MB) are loaded on-demand to keep core app light.")
                .font(.system(size: 13))
                .foregroundColor(Color.white.opacity(0.7))
                .multilineTextAlignment(.center)

            GlowButton(title: "Mount Creator Studio On-Demand", iconName: "arrow.down.square.fill") {
                viewModel.mountModule()
            }
        }
        .padding(30)
        .obsidianGlassCard()
    }
}
