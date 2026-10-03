//
//  MainTabView.swift
//  CosmosApp
//
//  Root View organizing MVVM navigation tabs in Obsidian Glass styling
//

import SwiftUI

public struct MainTabView: View {
    @State private var selectedTab = 0

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            SecurityDashboardView()
                .tabItem {
                    Label("Security", systemImage: "shield.3c")
                }
                .tag(0)

            SpatialChatView()
                .tabItem {
                    Label("Spatial Chat", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .tag(1)

            CreatorStudioView()
                .tabItem {
                    Label("Creator Studio", systemImage: "camera.viewfinder")
                }
                .tag(2)

            StorageManagementView()
                .tabItem {
                    Label("Storage", systemImage: "internaldrive.fill")
                }
                .tag(3)
        }
        .accentColor(ObsidianTheme.primaryCyan)
        .onAppear {
            // Configure dark translucent tab bar appearance
            #if os(iOS) && canImport(UIKit)
            let appearance = UITabBarAppearance()
            appearance.configureWithDarkBackground()
            appearance.backgroundColor = UIColor(red: 0.04, green: 0.06, blue: 0.09, alpha: 0.9)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            #endif
        }
    }
}
