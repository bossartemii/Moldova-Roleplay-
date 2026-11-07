# SanAndreasUnity integration decision

Audit date: 2026-11-07

## Selected upstream

- Repository: https://github.com/in0finite/SanAndreasUnity
- Canonical project organization referenced by upstream README: https://github.com/GTA-ASM/SanAndreasUnity
- Upstream default branch returned by GitHub: `dev`
- Upstream license: MIT, Copyright (c) 2015 James King (verified from top-level LICENSE).
- Engine: Unity; upstream README specifies Unity 2020.3.26 or newer.
- Platforms: upstream documents Windows, Linux, macOS and Android testing.
- Multiplayer: upstream documents dedicated-server, host and client modes, including Android.
- Extension: game modes/plugins via C# DLLs.
- Required game data: README says users must own GTA San Andreas and supply their own installation path. The repository does not grant rights to redistribute Rockstar game data.

## Decision

**Selected as the primary technical base candidate for Moldova Roleplay.** This replaces the earlier Godot/Reia-first direction. The current Godot scaffold is not the target client architecture if this integration proceeds.

## Legal and asset boundary

1. MIT applies to the upstream code covered by its LICENSE, not automatically to GTA San Andreas executable files, maps, models, textures, audio, logos, characters, trademarks or other Rockstar content.
2. Do not copy, commit, bundle, mirror, or distribute Rockstar game files or extracted assets.
3. Do not use the GTA name, Rockstar branding or recognizable protected assets as Moldova Roleplay branding.
4. Require each tester to provide legally obtained game data locally if the upstream runtime requires it. Investigate a clean original-asset pipeline before any public distribution.
5. Preserve the upstream MIT copyright and permission notice for imported code.
6. Audit every submodule separately. Upstream .gitmodules lists MirrorLite, UnityStandardAssets, NavMeshes, NetworkDiscoveryUnity and UGameCoreUtilities; their exact revisions and licenses must be pinned and reviewed before import.
7. This is a technical audit, not legal advice.

## Android and multiplayer caveats

The upstream README states Android is supported/tested and that multiplayer modes exist. That does not prove current compatibility with modern Android versions, ARM64-only devices, current Unity toolchains, Play Integrity, background networking, or acceptable performance on target phones.

Before shipping:
- Pin an exact upstream commit SHA and all submodule SHAs.
- Reproduce an unmodified Android build using the documented toolchain.
- Test install, launch, touch input, camera, vehicle entry/exit, multiplayer join/reconnect and thermal/performance behaviour on a physical Android device.
- Audit native plugins, C# packages, network protocol, server authority, authentication, persistence, anti-cheat and vulnerabilities.
- Confirm which game systems are actually implemented rather than inferred from screenshots or old releases.

## Moldova Roleplay conversion plan

Preserve the reusable engine/gameplay/multiplayer foundation where legally and technically sound. Replace the game-specific content and rules with original Moldova Roleplay systems:
- Original Chișinău-inspired map and assets, not GTA map exports.
- Original player identity and character creation.
- Serious roleplay jobs, public services, businesses and legal system.
- Vehicles and property using original/licensed assets.
- Economy in MDL with server-authoritative transactions.
- Romanian, Russian, Italian and English localization.
- Android-first touch HUD and adaptive UI.

## Current integration status

- [x] Verify public repository metadata and default branch.
- [x] Read upstream README.
- [x] Verify top-level MIT LICENSE.
- [x] Record submodule list and legal constraints.
- [ ] Pin upstream commit and submodule revisions.
- [ ] Audit complete source tree, dependencies and asset provenance.
- [ ] Build unmodified upstream for Android ARM64.
- [ ] Verify touch controls and multiplayer on physical device.
- [ ] Port/adapt only after passing the above gates.

No upstream source or Rockstar assets have been copied into this repository yet. The next implementation step is to import the audited codebase with full history/submodules and notices, not to graft isolated Godot scripts onto a Unity project.
