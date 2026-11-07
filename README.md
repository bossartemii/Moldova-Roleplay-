# Moldova Roleplay

Android-first 3D serious roleplay project set in Chișinău, Moldova.

## Active engine: Godot 4

The active development direction is **Godot 4**, using the existing Godot prototype as the base. The Unity/SanAndreasUnity experiment is retained in repository history and its existing integration branch; it is not the active runtime for this branch.

**Current state: early playable-prototype scaffold, not a finished game.** The repository contains a procedural greybox city block, a third-person capsule player, a follow camera and a basic touch HUD. It has not yet been built as an APK or tested on a physical Android device.

## Open the project

Use Godot 4.4 or a compatible Godot 4.x release:

1. Import this repository as a Godot project by selecting the root `project.godot`.
2. Run the main scene `scenes/main.tscn`.
3. The current scene is a placeholder greybox, not a detailed reconstruction of Chișinău.

## Android direction

- Android-first landscape gameplay and touch controls.
- Original Chișinău-inspired streets, districts and landmarks.
- Third-person movement, camera drag, sprint and jump.
- Original or separately licensed vehicles, buildings, clothing, characters and audio.
- Romanian, Russian, Italian and English localization.
- Future authoritative multiplayer server and persistent roleplay systems.

An Android APK still requires Godot export templates and the Android SDK/JDK configured in a build environment. No APK has been built or device-tested yet.

## Legal boundary

GTA San Andreas is not open source. Its source code, game data, map, models, textures, audio, characters and branding are not licensed for redistribution by this project. Do not commit, bundle or redistribute Rockstar assets. Use original assets or assets with explicit compatible licenses.

The SanAndreasUnity submodule and Unity documentation are retained as historical research only. They are not required to open or run the Godot project.

## Roadmap

See [Godot Android implementation plan](docs/GODOT_ANDROID_PLAN.md) and [open-source stack](docs/OPEN_SOURCE_STACK.md).

1. Stabilize the Godot scene and Android touch controls.
2. Add original low-poly city assets and a larger explorable district.
3. Implement a drivable vehicle prototype.
4. Add a dedicated authoritative multiplayer server.
5. Implement authentication, character identity, jobs, MDL economy, inventory and property persistence.
6. Build an ARM64 Android APK and test performance, touch input, safe areas and reconnect behavior on a physical device.

Do not describe multiplayer, persistence, a vehicle system or an Android release as implemented until it exists and has been tested.
