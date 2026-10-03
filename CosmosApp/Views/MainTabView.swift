//
//  MainTabView.swift
//  CosmosApp
//
//  Root View organizing MVVM navigation tabs in Obsidian Glass styling with custom Glassmorphic Bottom Navigation Bar
//

import SwiftUI

public struct MainTabView: View {
    @State private var selectedTab: TabItem = .feed

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            // Main Tab Views container with NavigationStack
            NavigationStack {
                Group {
                    switch selectedTab {
                    case .feed:
                        HomeFeedView()
                    case .studio:
                        CreatorStudioView()
                    case .chat:
                        SpatialChatView()
                    case .profile:
                        SecurityDashboardView()
                    case .storage:
                        StorageManagementView()
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }

            // Floating Glassmorphic Bottom Navigation Bar
            GlassmorphicTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 12)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(ObsidianTheme.darkBackground.ignoresSafeArea())
    }
}
