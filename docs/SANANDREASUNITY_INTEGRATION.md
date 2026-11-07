# SanAndreasUnity integration audit

Audit date: 2026-11-07

## Pinned upstream

- Source: https://github.com/in0finite/SanAndreasUnity
- Canonical project organization referenced by upstream: https://github.com/GTA-ASM/SanAndreasUnity
- Upstream branch inspected: `dev`
- Exact pinned commit: `f685c437f48721afc0787f27d22c85d96e8684c7`
- Commit date: 2022-09-30
- Commit message: `remove some unused files`
- Upstream Unity project version: `2020.3.26f1`
- Top-level license: MIT, Copyright (c) 2015 James King.
- The engine is registered in this repository as a Git submodule at `vendor/SanAndreasUnity`. It is a pinned reference, not a copied or adapted Moldova game.

Important: the `dev` branch's latest commit resolved during this audit is from 2022. The project is therefore a legacy candidate, not a currently maintained, production-ready Android foundation. Pinning it makes the source reproducible; it does not make it modern or secure.

## What the upstream actually provides

The upstream README documents:
- A Unity reimplementation of parts of the GTA San Andreas engine, not a complete GTA SA reimplementation.
- Gameplay systems, vehicles/characters/world loading and multiplayer infrastructure.
- Dedicated-server, host and client modes.
- C# DLL game-mode/plugin extension.
- Android support/testing and touch controls in historical mobile releases.
- A requirement for the player to supply a legally obtained GTA San Andreas installation/data path.

These are upstream claims and historical capabilities. They are not proof that the pinned project builds on current Android, works on current devices, or is production-safe.

## Android blockers found in the checked-in settings

The pinned `ProjectSettings/ProjectSettings.asset` contains:
- Unity editor: `2020.3.26f1`
- Minimum Android SDK: API 19
- Target Android SDK: API 28
- `AndroidTargetArchitectures: 1`, which is ARMv7 only in Unity's AndroidArchitecture enum; ARM64 is not selected.
- The project therefore is not configured for the required modern ARM64 Android release target.

References:
- Unity Android architecture enum: https://github.com/Unity-Technologies/UnityCsReference/blob/master/Editor/Mono/PlayerSettingsAndroid.bindings.cs
- Android 64-bit build guidance: https://developer.android.com/games/optimize/64-bit

Do not attempt a release build from these settings unchanged. The project needs a controlled Unity upgrade, IL2CPP + ARM64 configuration, current Android SDK/target settings, and an actual device build/test. A Unity upgrade may break old packages, scripts or serialized assets; it must be tested rather than assumed safe.

## Multiplayer and server-authority risk

The upstream `Docs/Multiplayer.md` still lists unresolved networking TODOs, including laggy vehicle synchronization and a design note where clients control rigid bodies while the server validates/corrects state. That is not sufficient evidence of authoritative anti-cheat or a secure serious-roleplay economy.

Before any public server:
- Move money, inventory, jobs, ownership, damage, rewards and moderation decisions behind server-side validation.
- Treat every client message as untrusted.
- Add authentication, authorization, rate limits, persistence, audit logs and reconnect handling.
- Test cheating, replay, desync, disconnect and load scenarios.
- Do not expose a production server until security and load tests pass.

## Submodules and license audit

The upstream `.gitmodules` pins these nested repositories at the following commits:

| Component | Pinned commit | License status found in this audit |
|---|---|---|
| MirrorLite | `98787809637f08a8dd4aa39163340f0faf29cd6a` | No root LICENSE file or GitHub license metadata found; unresolved |
| UnityStandardAssets | `c5d2f860cad8fbe1f535261d305578ef25fe1a67` | No root LICENSE file or GitHub license metadata found; unresolved |
| NavMeshes | `5d677c959befb9789e5610451a61eea52542f142` | No root LICENSE file or GitHub license metadata found; unresolved |
| NetworkDiscoveryUnity | `b961d7b8b387cb53255078dcaad480286817d7ab` | MIT verified |
| UGameCoreUtilities | `f2ed4500c5bd1ecbe89dc3d3998d660b6b010af1` | No root LICENSE file or GitHub license metadata found; unresolved |

Do not assume the top-level MIT license covers these separately versioned submodules. Their licensing and redistribution rights must be resolved before shipping. The source also contains prebuilt `NVorbis.dll` and `Newtonsoft.Json.dll`; exact versions, provenance and applicable notices still need verification.

## Source and asset boundary

The upstream source repository contains Unity scenes, scripts, prefabs, textures, plugins and nested submodules. The initial file inventory did not identify obvious GTA archive formats such as `.img`, `.dff` or `.txd`, but that is not a complete provenance audit.

The MIT license does not grant rights to Rockstar game files, extracted map data, models, textures, audio, characters, logos or trademarks. Do not copy, bundle, mirror or redistribute those assets. Moldova Roleplay must use original Chișinău-inspired environments, original characters, original vehicles or separately licensed assets. Replace upstream branding and any asset whose rights cannot be established.

## Integration made in this repository

- [x] Created `.gitmodules` entry for `vendor/SanAndreasUnity`.
- [x] Added a Git submodule pointer to the exact upstream commit above.
- [x] Recorded the nested submodule commit IDs and license gaps.
- [x] Preserved the existing Godot prototype and its files; nothing was deleted.
- [ ] Initialize nested submodules locally and verify every checkout.
- [ ] Resolve all third-party license and binary provenance gaps.
- [ ] Open the Unity project in the pinned editor and record import/compiler errors.
- [ ] Upgrade Unity and Android build settings in a separate branch.
- [ ] Produce an unmodified ARM64/IL2CPP debug APK.
- [ ] Install and test on a physical Android device, including touch controls.
- [ ] Audit multiplayer/server authority and run security/load tests.
- [ ] Only then begin replacing GTA-specific content with Moldova systems.

## Moldova Roleplay conversion target

- Original Chișinău map and district layout; no GTA map exports.
- Original character creation, identity and serious-RP rules.
- Jobs, public services, companies and legal system.
- Original/licensed vehicles, buildings, clothing and audio.
- Server-authoritative economy in MDL, inventory and property.
- Romanian, Russian, Italian and English localization.
- Android-first touch controls and adaptive HUD.

## Current status

The repository now points to a pinned upstream engine through a Git submodule. The Unity project has **not** been built, upgraded, adapted into Moldova Roleplay or tested on an Android device. No APK has been produced. This is an integration checkpoint, not a playable release.
