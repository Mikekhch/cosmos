//
//  GlassmorphicTabBar.swift
//  CosmosApp
//
//  Unified Glassmorphic Bottom Navigation Bar in Obsidian Glass styling
//

import SwiftUI

public enum TabItem: Int, CaseIterable, Identifiable {
    case feed = 0
    case studio = 1
    case chat = 2
    case profile = 3
    case storage = 4

    public var id: Int { self.rawValue }

    public var title: String {
        switch self {
        case .feed: return "Canvas"
        case .studio: return "Studio"
        case .chat: return "Spatial"
        case .profile: return "Profile"
        case .storage: return "Storage"
        }
    }

    public var iconName: String {
        switch self {
        case .feed: return "view.in.ar"
        case .studio: return "camera.viewfinder"
        case .chat: return "bubble.left.and.bubble.right.fill"
        case .profile: return "shield.3c.fill"
        case .storage: return "internaldrive.fill"
        }
    }
}

public struct GlassmorphicTabBar: View {
    @Binding public var selectedTab: TabItem

    public init(selectedTab: Binding<TabItem>) {
        self._selectedTab = selectedTab
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: selectedTab == tab ? 18 : 16, weight: selectedTab == tab ? .bold : .medium))
                            .foregroundColor(selectedTab == tab ? ObsidianTheme.primaryCyan : Color.white.opacity(0.6))
                            .scaleEffect(selectedTab == tab ? 1.15 : 1.0)
                            .shadow(color: selectedTab == tab ? ObsidianTheme.primaryCyan.opacity(0.8) : .clear, radius: 8)

                        Text(tab.title)
                            .font(.system(size: 10, weight: selectedTab == tab ? .bold : .regular, design: .monospaced))
                            .foregroundColor(selectedTab == tab ? ObsidianTheme.primaryCyan : Color.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
            }
        }
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.white.opacity(0.06))
                .background(
                    RoundedRectangle(cornerRadius: 32)
                        .fill(ObsidianTheme.surfaceContainer.opacity(0.85))
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.25),
                            ObsidianTheme.primaryCyan.opacity(0.3),
                            Color.white.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.6), radius: 20, x: 0, y: 10)
        .shadow(color: ObsidianTheme.primaryCyan.opacity(0.15), radius: 15, x: 0, y: 0)
        .padding(.horizontal, 16)
    }
}
