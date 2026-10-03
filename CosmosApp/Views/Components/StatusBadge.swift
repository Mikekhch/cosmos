//
//  StatusBadge.swift
//  CosmosApp
//
//  Pill Badge Capsule Component for System Telemetry
//

import SwiftUI

public struct StatusBadge: View {
    public let text: String
    public let color: Color
    public var iconName: String?

    public init(text: String, color: Color = ObsidianTheme.tertiaryEmerald, iconName: String? = nil) {
        self.text = text
        self.color = color
        self.iconName = iconName
    }

    public var body: some View {
        HStack(spacing: 6) {
            if let iconName = iconName {
                Image(systemName: iconName)
                    .font(.system(size: 10, weight: .bold))
            } else {
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)
            }
            Text(text)
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
        }
        .foregroundColor(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color.opacity(0.12))
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}
