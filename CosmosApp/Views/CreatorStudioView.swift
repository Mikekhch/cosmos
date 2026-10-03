//
//  CreatorStudioView.swift
//  CosmosApp
//
//  On-Demand Dynamic Feature View: Creator Studio Video Frame Capture
//

import SwiftUI

public struct CreatorStudioView: View {
    @StateObject private var viewModel = CreatorStudioViewModel()

    public init() {}

    public var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("DYNAMIC FEATURE MODULE")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.primaryCyan)
                    Text("Creator Studio")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                StatusBadge(text: viewModel.isModuleMounted ? "MODULE MOUNTED" : "ON-DEMAND", color: viewModel.isModuleMounted ? ObsidianTheme.tertiaryEmerald : .orange)
            }
            .padding(.top, 10)

            if viewModel.isModuleMounted {
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.black.opacity(0.8))
                            .frame(height: 320)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(ObsidianTheme.primaryCyan.opacity(0.4), lineWidth: 1)
                            )

                        VStack(spacing: 12) {
                            Image(systemName: "camera.metering.matrix")
                                .font(.system(size: 48))
                                .foregroundColor(ObsidianTheme.primaryCyan)
                            Text("Cyberpunk AR Video Frame Preview")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            Text("Filter: \(viewModel.activeFilter)")
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(ObsidianTheme.secondaryIndigo)
                        }
                    }

                    HStack(spacing: 16) {
                        GlowButton(title: "Capture Frame & Offload", iconName: "camera.fill") {
                            viewModel.captureVideoFrame()
                        }
                    }
                }
            } else {
                VStack(spacing: 16) {
                    Text("Creator Studio assets (45MB) are loaded on-demand to keep core app download light.")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)

                    GlowButton(title: "Mount Creator Studio On-Demand", iconName: "arrow.down.square.fill") {
                        viewModel.mountModule()
                    }
                }
                .padding(30)
                .obsidianGlassCard()
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .background(ObsidianTheme.darkBackground.ignoresSafeArea())
        .onAppear {
            viewModel.checkModuleStatus()
        }
    }
}
