//
//  ObsidianTheme.swift
//  CosmosApp
//
//  Obsidian Glass Design System Colors, Gradients & Glass View Modifiers
//  Strictly adheres to stitch_mikekh/obsidian_glass/DESIGN.md
//

import SwiftUI

public enum ObsidianTheme {
    // Brand Colors
    public static let primaryCyan = Color(red: 0x00/255.0, green: 0xF0/255.0, blue: 0xFF/255.0)     // #00F0FF
    public static let secondaryIndigo = Color(red: 0x63/255.0, green: 0x66/255.0, blue: 0xF1/255.0)  // #6366F1
    public static let tertiaryEmerald = Color(red: 0x10/255.0, green: 0xB9/255.0, blue: 0x81/255.0)  // #10B981
    public static let darkBackground = Color(red: 0x0B/255.0, green: 0x0F/255.0, blue: 0x17/255.0)   // #0B0F17
    public static let surfaceContainer = Color(red: 0x1C/255.0, green: 0x20/255.0, blue: 0x28/255.0)  // #1C2028

    // Gradients
    public static let primaryGlowGradient = LinearGradient(
        colors: [primaryCyan, secondaryIndigo],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let emeraldGlowGradient = LinearGradient(
        colors: [tertiaryEmerald, primaryCyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// Glassmorphism View Modifier
public struct ObsidianGlassCardModifier: ViewModifier {
    public var cornerRadius: CGFloat
    public var borderOpacity: Double

    public init(cornerRadius: CGFloat = 24, borderOpacity: Double = 0.15) {
        self.cornerRadius = cornerRadius
        self.borderOpacity = borderOpacity
    }

    public func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white.opacity(0.06))
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(ObsidianTheme.surfaceContainer.opacity(0.7))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(borderOpacity * 1.5),
                                Color.white.opacity(borderOpacity * 0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.4), radius: 16, x: 0, y: 8)
    }
}

public extension View {
    func obsidianGlassCard(cornerRadius: CGFloat = 24, borderOpacity: Double = 0.15) -> some View {
        self.modifier(ObsidianGlassCardModifier(cornerRadius: cornerRadius, borderOpacity: borderOpacity))
    }
}
