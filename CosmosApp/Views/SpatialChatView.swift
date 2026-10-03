//
//  SpatialChatView.swift
//  CosmosApp
//
//  View for Spatial Chat with E2EE Protection
//

import SwiftUI

public struct SpatialChatView: View {
    @StateObject private var viewModel = SpatialChatViewModel()

    public init() {}

    public var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("SPATIAL E2EE PROTOCOL")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(ObsidianTheme.primaryCyan)
                    Text("Encrypted Spatial Chat")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                StatusBadge(text: "AES-256 E2EE", color: ObsidianTheme.tertiaryEmerald)
            }
            .padding(.top, 10)

            // Messages list
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        HStack {
                            if message.senderId == "CURRENT_USER" { Spacer() }

                            VStack(alignment: message.senderId == "CURRENT_USER" ? .trailing : .leading, spacing: 4) {
                                Text(message.plaintextOverride ?? message.encryptedContent)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)

                                HStack(spacing: 4) {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 8))
                                    Text("Encrypted Payload (Nonce: \(message.nonce.prefix(8))...)")
                                        .font(.system(size: 9, design: .monospaced))
                                }
                                .foregroundColor(ObsidianTheme.primaryCyan.opacity(0.8))
                            }
                            .padding(12)
                            .background(
                                message.senderId == "CURRENT_USER"
                                ? ObsidianTheme.primaryGlowGradient.opacity(0.4)
                                : Color.white.opacity(0.08)
                            )
                            .cornerRadius(16)

                            if message.senderId != "CURRENT_USER" { Spacer() }
                        }
                    }
                }
            }

            // Input bar
            HStack(spacing: 10) {
                TextField("Send E2EE message...", text: $viewModel.messageInput)
                    .padding(12)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(20)
                    .foregroundColor(.white)

                GlowButton(title: "Send", iconName: "paperplane.fill") {
                    viewModel.sendEncryptedMessage()
                }
            }
            .padding(.bottom, 10)
        }
        .padding(.horizontal, 16)
        .background(ObsidianTheme.darkBackground.ignoresSafeArea())
    }
}
