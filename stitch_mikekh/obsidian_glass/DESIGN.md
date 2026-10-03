---
name: Obsidian Glass
colors:
  surface: '#0f131c'
  surface-dim: '#0f131c'
  surface-bright: '#353942'
  surface-container-lowest: '#0a0e16'
  surface-container-low: '#181c24'
  surface-container: '#1c2028'
  surface-container-high: '#262a33'
  surface-container-highest: '#31353e'
  on-surface: '#dfe2ee'
  on-surface-variant: '#b9cacb'
  inverse-surface: '#dfe2ee'
  inverse-on-surface: '#2c3039'
  outline: '#849495'
  outline-variant: '#3b494b'
  surface-tint: '#00dbe9'
  primary: '#dbfcff'
  on-primary: '#00363a'
  primary-container: '#00f0ff'
  on-primary-container: '#006970'
  inverse-primary: '#006970'
  secondary: '#c0c1ff'
  on-secondary: '#1000a9'
  secondary-container: '#3131c0'
  on-secondary-container: '#b0b2ff'
  tertiary: '#d8ffe7'
  on-tertiary: '#003824'
  tertiary-container: '#65f2b5'
  on-tertiary-container: '#006d4a'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#7df4ff'
  primary-fixed-dim: '#00dbe9'
  on-primary-fixed: '#002022'
  on-primary-fixed-variant: '#004f54'
  secondary-fixed: '#e1e0ff'
  secondary-fixed-dim: '#c0c1ff'
  on-secondary-fixed: '#07006c'
  on-secondary-fixed-variant: '#2f2ebe'
  tertiary-fixed: '#6ffbbe'
  tertiary-fixed-dim: '#4edea3'
  on-tertiary-fixed: '#002113'
  on-tertiary-fixed-variant: '#005236'
  background: '#0f131c'
  on-background: '#dfe2ee'
  surface-variant: '#31353e'
typography:
  display-hero:
    fontFamily: Plus Jakarta Sans
    fontSize: 56px
    fontWeight: '700'
    lineHeight: 64px
    letterSpacing: -0.03em
  display-hero-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.025em
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 40px
    fontWeight: '600'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-xl-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: -0.005em
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0em
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-mono-sm:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.04em
  label-mono-xs:
    fontFamily: JetBrains Mono
    fontSize: 10px
    fontWeight: '500'
    lineHeight: 12px
    letterSpacing: 0.06em
  badge-caps:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.08em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-tablet: 1.5rem
  gutter-desktop: 2rem
  margin: 1rem
  margin-tablet: 2rem
  margin-desktop: 3rem
  space-2xs: 0.25rem
  space-xs: 0.5rem
  space-sm: 0.75rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
  space-2xl: 3rem
  space-3xl: 4rem
---

## Brand & Style

This design system channels an advanced, futuristic iOS SwiftUI aesthetic rooted in deep midnight atmosphere, optical refraction, and luminous kinetic feedback. Engineered for high-engagement, next-generation mobile and desktop interfaces, it evokes precision, technical mastery, and spatial depth. 

The aesthetic is ultra-refined **Glassmorphism married to Cyber-Minimalism**:
- **Atmospheric Canvas:** Interfaces emerge from an obsidian void rather than flat dark grays, evoking infinite depth.
- **Optical Materiality:** Surfaces emulate milled crystal and liquid glass through layered backdrop blurs, directional specular highlights, and hairline translucent strokes.
- **Luminescent Telemetry:** Neon accents in electric cyan, ultraviolet indigo, and liquid emerald act as emissive light sources, casting soft ambient glows across neighboring glass panels.
- **Tactile Fluidity:** Interactions simulate native iOS physics—spring-loaded compressions, variable-rate blurs, and luminous border sweeps upon user touch.

## Colors

The palette balances profound dark values with emissive, spectral energy:

- **Primary (`#00F0FF` - Electric Cyan):** The primary focal vector. Used for critical states, active interactive elements, playback progress heads, audio visualizer peaks, and high-priority CTAs.
- **Secondary (`#6366F1` - Electric Indigo/Violet):** Used for structural accents, secondary pathways, gradient interplays with Cyan, and contextual grouping.
- **Tertiary (`#10B981` - Vibrant Emerald):** Reserved strictly for positive yields, token transactions, system health, rewards, and successful states.
- **Neutral Base (`#0B0F17` to `#111827`):** The foundational obsidian canvas. Elevated surfaces do not introduce opaque light grays; instead, they layer pure white at varying opacities (`rgba(255, 255, 255, 0.03)` to `rgba(255, 255, 255, 0.12)`) on top of deep glass materials.
- **Specular & Hairline System:** 
  - Glass Border: `rgba(255, 255, 255, 0.10)`
  - Edge Highlight (Top/Left inner shadow): `inset 0 1px 1px 0 rgba(255, 255, 255, 0.18)`
  - Emissive Glow: `0 0 24px -4px rgba(0, 240, 255, 0.35)`

## Typography

Typography delivers an Apple SF Pro-adjacent aesthetic using Plus Jakarta Sans for pristine geometric balance, clarity, and humanist warmth in compact mobile viewports. JetBrains Mono is deployed surgically for numerical metrics, token counters, timecodes, and telemetry feeds.

- **Weight Hierarchy:** Keep interface labels compact and tight. Use `600` and `700` weight primarily on titles to ground the airy glass surfaces. Body copy sits strictly at regular `400` weight to prevent visual heaviness.
- **Negative Tracking:** Apply negative letter-spacing dynamically to all headlines above 20px to reproduce Apple’s cohesive display typesetting.
- **Tabular Numerics:** All price readouts, reward totals, and waveform audio markers must leverage tabular/monospaced metrics to ensure transitions do not cause horizontal layout shifts.

## Layout & Spacing

The layout structure leverages a fluid columnar matrix configured for mobile-first native adaptation:

- **Breakpoints & Grids:**
  - **Compact (Mobile < 640px):** 4-column layout, 16px margins, 16px gutters.
  - **Medium (Tablet 640px - 1024px):** 8-column layout, 32px margins, 24px gutters.
  - **Expanded (Desktop > 1024px):** 12-column layout, max-width 1280px centered, 48px margins, 32px gutters.
- **Vertical Rhythm:** 4px baseline sub-grid. Padding within glass containers must be generous (`space-lg` to `space-xl`) to allow the frosted backdrop to breathe without visual crowding.
- **Safe Area Insets:** Adhere to native bottom bar gesture areas (padding bottom `space-xl` minimum on iOS shells) and dynamic island/notch overhead clearances.

## Elevation & Depth

Spatial separation is achieved through layered optical refraction, variable backdrop filters, and light dispersion rather than traditional opaque drop shadows.

- **Tier 0 (Infinite Canvas):** Solid base `#0B0F17` overlaid with subtle dynamic radial gradients of indigo (`#6366F1` at 8% opacity) and cyan (`#00F0FF` at 5% opacity) blurred at 120px.
- **Tier 1 (Base Glass Surface):** `background: rgba(17, 24, 39, 0.65)`, `backdrop-filter: blur(24px) saturate(180%)`. Border is `1px solid rgba(255, 255, 255, 0.08)`. Inner highlight: `inset 0 1px 0 0 rgba(255, 255, 255, 0.12)`.
- **Tier 2 (Floating Glass Modal / Active Element):** `background: rgba(255, 255, 255, 0.08)`, `backdrop-filter: blur(36px) saturate(200%)`. Border is `1px solid rgba(255, 255, 255, 0.18)`. Shadow: `0 16px 40px -8px rgba(0, 0, 0, 0.5)`.
- **Tier 3 (Active Luminescent Element):** Glowing states cast direct light. Shadows use the parent hue: `box-shadow: 0 0 30px -4px rgba(0, 240, 255, 0.4), inset 0 0 12px 0 rgba(0, 240, 255, 0.2)`.
- **Specular Edge Technique:** Card and sheet headers feature a gradient border mask (`linear-gradient(180deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.02) 100%)`) mimicking top-down directional lighting.

## Shapes

The geometry mirrors Apple’s super-ellipse (squircle) design language:

- **Primary Cards & Containers:** High-curvature `rounded-3xl` (24px to 32px) creates the characteristic polished, organic look of iOS tactile widgets.
- **Pills & Badges:** Fully circular radii (`9999px`) for chips, status tags, numeric reward capsules, and interactive action buttons.
- **Interior Nesting Rule:** Nested interactive elements inside a card must follow concentric corner ratios: `Radius(Inner) = Radius(Outer) - Padding`. For a 28px card with 16px padding, inner targets must have a 12px corner radius to preserve harmonious sightlines.

## Components

### Buttons & Interactive Triggers
- **Primary Glow Button:** Capsule pill shape. Background is a vibrant gradient from `#00F0FF` to `#6366F1`. Text is bold black or deep navy (`#0B0F17`). Outer glow: `0 0 20px rgba(0, 240, 255, 0.3)`. On press, trigger a scale down to `0.97` with spring damping.
- **Frosted Glass Button (Secondary):** Capsule pill. Background: `rgba(255, 255, 255, 0.08)`. Border: `1px solid rgba(255, 255, 255, 0.15)`. Text: white. Hover/Focus activates an electric cyan hairline outline.

### Cards & Modular Containers
- Constructed with Tier 1 frosted glass styling.
- Contain a subtle top-to-bottom translucent specular gradient along the border.
- Headers integrate metadata badges or icon capsules recessed in `rgba(0, 0, 0, 0.25)` backdrops.

### Audio Waveform Visualizers
- Rendered as vertical bars with rounded pill tips.
- Passive bars: `rgba(255, 255, 255, 0.15)`.
- Active/Played bars: Solid `#00F0FF` transitioning dynamically into `#6366F1` based on frequency intensity. Peak pulses project an ambient cyan bloom.

### Badges & Token Rewards
- **Pill Badges:** Monospace or condensed text enclosed within translucent capsules.
- **Emerald Reward Capsule:** Background `rgba(16, 185, 129, 0.12)`, border `1px solid rgba(16, 185, 129, 0.3)`, text `#10B981`. Features a breathing ambient glow when accumulating value.

### Form Inputs & Text Fields
- Recessed pill or `rounded-2xl` fields with `background: rgba(0, 0, 0, 0.3)`.
- Resting border: `rgba(255, 255, 255, 0.08)`.
- Active focus state: Replaces border with an electric cyan gradient stroke and an inner ambient illumination glow (`inset 0 0 10px rgba(0, 240, 255, 0.15)`).

### Selection Controls (Toggles, Checkboxes, Radios)
- **SwiftUI-style Switches:** Track is frosted dark obsidian (`rgba(255, 255, 255, 0.1)`), thumb is a pure white orb with a high-specular sheen. Active track transitions seamlessly to `#00F0FF` with a cyan drop glow.