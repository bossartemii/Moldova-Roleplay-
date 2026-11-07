# Moldova Roleplay

Android-first 3D serious roleplay prototype set in Chișinău, Moldova.

## Status
Early Godot 4 scaffold. This is not a complete multiplayer game and no APK has been built or device-tested yet.

## Stack
- Godot 4 / GDScript
- Android ARM64 target
- Compatibility renderer
- Original procedural greybox; no GTA/SA-MP assets or third-party map meshes included

## Run
Import `project.godot` in Godot 4.x and run `scenes/main.tscn`.

## Android export
Install matching Godot export templates, Android SDK and JDK; configure an Android export preset, then export a debug APK. Never commit signing keys.

## Roadmap
1. Android playable prototype
2. Chișinău district blockout and original assets
3. Authentication and character creation
4. Authoritative multiplayer server and persistence
5. Serious RP jobs, economy, police, EMS, vehicles and properties
6. Anti-cheat, moderation, load testing and release APK

## Licensing
Project-authored code is MIT. Third-party assets require a recorded source, exact license and attribution in `THIRD_PARTY_NOTICES.md` before inclusion.