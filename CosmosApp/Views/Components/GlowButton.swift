//
//  GlowButton.swift
//  CosmosApp
//
//  Interactive Electric Cyan / Indigo Glow Button
//

import SwiftUI

public struct GlowButton: View {
    public let title: String
    public let iconName: String?
    public let action: () -> Void
    public var isAccent: Bool

    public init(
        title: String,
        iconName: String? = nil,
        isAccent: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.isAccent = isAccent
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .font(.system(size: 14, weight: .bold))
                }
                Text(title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
            }
            .foregroundColor(isAccent ? ObsidianTheme.darkBackground : Color.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Group {
                    if isAccent {
                        Capsule().fill(ObsidianTheme.primaryGlowGradient)
                    } else {
                        Capsule().fill(Color.white.opacity(0.12))
                    }
                }
            )
            .overlay(
                Capsule()
                    .stroke(
                        isAccent ? ObsidianTheme.primaryCyan.opacity(0.6) : Color.white.opacity(0.2),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: isAccent ? ObsidianTheme.primaryCyan.opacity(0.4) : Color.clear,
                radius: 12,
                x: 0,
                y: 0
            )
        }
    }
}
