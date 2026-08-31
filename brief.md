# Liquid Glass Showcase - Source Brief

## Title
Liquid Glass Showcase

## Description
A Flutter demo app that shows Apple's iOS 26 Liquid Glass design language done right - frosted, shader-blurred glass widgets layered over real imagery so the glass refracts the artwork behind it. It composes the glass primitives from the liquid_glass_widgets package into a single polished home screen: a photographic backdrop, a "Now Playing" hero card with an album-art strip and a glass Play button, two photo tiles, an interactive glass controls card (switches + slider), and a frosted glass tab bar.

## Store links
Not yet published (portfolio POC).

## Platform
iOS and Android (Flutter). Tuned for iOS 26 / Impeller.

## Category
UI / Design system demo.

## Features
- Full-bleed photographic backdrop that the glass surfaces refract and blur.
- Hero card: photo + brand scrim + overlapping album-art thumbnails + frosted GlassButton.
- Two accent photo tiles (Nature, Travel).
- Interactive glass controls card: two GlassSwitch toggles + a GlassSlider.
- Frosted GlassTabBar bottom bar (Home / Library / Settings).
- Original mesh-gradient backdrop art generated with Python + Pillow.

## Tech stack
Flutter (Cupertino), liquid_glass_widgets ^1.2.1, Python + Pillow for asset generation.

## Industry
Consumer mobile / design systems.

## Metrics
Unpublished POC - no install metrics. Renders at 60fps on the iOS 17 Pro simulator under Impeller.

## Research notes
- Verified: builds and runs on the iPhone 17 Pro simulator (debug); flutter analyze clean; the package's glass widgets (GlassScaffold, GlassTabBar, GlassCard, GlassButton, GlassSwitch, GlassSlider) render over the photographic backdrop.
- Assumed/mocked: all content is static demo data; the backdrop "photos" are original generated gradients, not photography; tab bar tabs are visual only (no separate routes).
