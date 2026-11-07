# Moldova Roleplay

Android-first 3D serious roleplay project set in Chișinău, Moldova.

## Current status

The repository now contains a pinned Git submodule reference to the SanAndreasUnity engine candidate at `vendor/SanAndreasUnity`.

**This is not yet a playable Moldova Roleplay build.** The selected upstream is a legacy Unity project (2020.3.26f1; last inspected upstream commit dated 2022-09-30). Its checked-in Android settings target API 28 and ARMv7 only. ARM64, modern Android SDK settings, current Unity compatibility, dependency licensing and physical-device tests are still open.

The previous Godot prototype remains in the repository unchanged as legacy work. The active engine evaluation is Unity; Godot scripts are not part of the Unity runtime.

## Get the source

Clone with all submodules:

```bash
git clone --recurse-submodules https://github.com/bossartemii/Moldova-Roleplay-.git
cd Moldova-Roleplay-
git submodule update --init --recursive
```

Open `vendor/SanAndreasUnity` in the Unity editor version recorded in its `ProjectSettings/ProjectVersion.txt` (2020.3.26f1 for the pinned revision).

Do not treat that old editor version as the final release toolchain. The Android migration plan requires a separate, tested Unity upgrade and an IL2CPP + ARM64 build configuration.

## Product direction

- Original Chișinău-inspired city map and districts.
- Serious roleplay with character identity, jobs, public services and businesses.
- Server-authoritative MDL economy, inventory, property and progression.
- Original/licensed vehicles, buildings, clothing, characters and audio.
- Romanian, Russian, Italian and English localization.
- Android-first touch HUD, virtual joystick, camera drag and contextual action buttons.

## Legal boundary

SanAndreasUnity's upstream code is MIT-licensed at the pinned revision. Its nested dependencies have separate license status; some remain unverified. GTA San Andreas game data and Rockstar assets are not covered by that MIT license. Do not commit, bundle or redistribute them. Moldova Roleplay must use original or separately licensed assets.

## Audit and roadmap

See [SanAndreasUnity integration audit](docs/SANANDREASUNITY_INTEGRATION.md), [open-source stack](docs/OPEN_SOURCE_STACK.md) and [third-party notices](THIRD_PARTY_NOTICES.md).

1. Resolve nested dependency licenses and binary provenance.
2. Open the pinned Unity project and record import/compiler errors.
3. Upgrade Unity and Android settings in a separate branch.
4. Build an ARM64/IL2CPP debug APK and test on a physical Android device.
5. Validate touch controls, networking, server authority, security and performance.
6. Replace upstream game-specific content with original Moldova Roleplay systems.

No APK has been built or device-tested yet. Do not publish or advertise this as a playable release.
