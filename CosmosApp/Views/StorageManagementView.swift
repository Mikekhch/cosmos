//
//  StorageManagementView.swift
//  CosmosApp
//
//  View for Smart Cache Management (300MB Strict Limit, Auto-Purge & Dynamic Modules)
//

import SwiftUI

public struct StorageManagementView: View {
    @StateObject private var viewModel = StorageManagerViewModel()

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("STORAGE & APP SIZE OPTIMIZATION")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(ObsidianTheme.primaryCyan)
                        Text("Cache & Module Control")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    StatusBadge(
                        text: "\(Int(Double(viewModel.currentCacheSizeBytes) / (1024 * 1024))) MB / 300 MB",
                        color: viewModel.currentCacheSizeBytes > (250 * 1024 * 1024) ? Color.orange : ObsidianTheme.tertiaryEmerald
                    )
                }
                .padding(.top, 10)

                // Cache Quota Progress Gauge
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Cache Capacity (300MB Strict Limit)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(String(format: "%.1f", Double(viewModel.currentCacheSizeBytes) / (1024 * 1024))) MB")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(ObsidianTheme.primaryCyan)
                    }

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 10)

                            let ratio = min(1.0, Double(viewModel.currentCacheSizeBytes) / Double(300 * 1024 * 1024))
                            Capsule()
                                .fill(ratio > 0.85 ? Color.orange : ObsidianTheme.primaryCyan)
                                .frame(width: geo.size.width * ratio, height: 10)
                        }
                    }
                    .frame(height: 10)

                    HStack {
                        GlowButton(title: "+ Add Sample Media (85MB)", iconName: "plus.circle.fill") {
                            viewModel.simulateAddCacheMediaItem()
                        }

                        GlowButton(title: "Purge All Cache", iconName: "trash.fill", isAccent: false) {
                            viewModel.purgeAllCache()
                        }
                    }
                    .padding(.top, 6)
                }
                .padding(16)
                .obsidianGlassCard()

                // On-Demand Dynamic Feature Modules
                VStack(alignment: .leading, spacing: 12) {
                    Text("Dynamic Feature Modules (On-Demand Loading)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)

                    ForEach(Array(viewModel.onDemandFeatures.values), id: \.id) { feature in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(feature.displayName)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("On-Demand Bundle Size: \(String(format: "%.1f", feature.downloadSizeMB)) MB | Memory RAM: \(String(format: "%.1f", feature.memoryUsageMB)) MB")
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundColor(Color.white.opacity(0.6))
                            }
                            Spacer()

                            switch feature.state {
                            case .notDownloaded:
                                GlowButton(title: "Download", iconName: "arrow.down.circle") {
                                    viewModel.downloadFeatureModule(id: feature.id)
                                }
                            case .downloading(let progress):
                                Text("\(Int(progress * 100))%")
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                                    .foregroundColor(ObsidianTheme.primaryCyan)
                            case .installed:
                                if feature.isLoadedInMemory {
                                    GlowButton(title: "Unload RAM", iconName: "memorychip", isAccent: false) {
                                        viewModel.unloadFeatureMemory(id: feature.id)
                                    }
                                } else {
                                    StatusBadge(text: "INSTALLED (UNLOADED)", color: ObsidianTheme.tertiaryEmerald)
                                }
                            case .error(let msg):
                                Text("Error: \(msg)")
                                    .font(.system(size: 10))
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(12)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                    }
                }
                .padding(16)
                .obsidianGlassCard()

                // Active Server Media Processing Jobs (FFmpeg Offload)
                VStack(alignment: .leading, spacing: 12) {
                    Text("FFmpeg Server-Side Offload Tasks")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)

                    if viewModel.offloadJobs.isEmpty {
                        Text("No active server transcoding jobs.")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(Color.white.opacity(0.5))
                    } else {
                        ForEach(viewModel.offloadJobs) { job in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(job.sourceFileName)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.white)
                                    if let ratio = job.compressionRatio {
                                        Text("Saved \(Int(ratio * 100))% via H.265 Transcode -> Auto-Purged Local File")
                                            .font(.system(size: 10, design: .monospaced))
                                            .foregroundColor(ObsidianTheme.tertiaryEmerald)
                                    }
                                }
                                Spacer()
                                StatusBadge(
                                    text: job.status.rawValue,
                                    color: job.status == .completed ? ObsidianTheme.tertiaryEmerald : ObsidianTheme.primaryCyan
                                )
                            }
                            .padding(10)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(8)
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
