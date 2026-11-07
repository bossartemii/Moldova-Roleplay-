# Reia game-base audit

Audit date: 2026-11-07

## Candidate

- Project: https://github.com/Quaint-Studios/Reia
- Description: open-source 3D action-adventure RPG built with Godot and Rust.
- Upstream branch shown by GitHub: `master`.
- Public repository snapshot: approximately 1,030 commits and 991 stars at audit time.
- Repository topics include Godot 4, 3D, MMO/MMORPG, multiplayer and mobile-game.
- README describes offline play, online co-op and an intended MMO mode; it also describes procedural areas, character progression, player-owned islands, marketplace and modding.

## Fit for Moldova Roleplay

Potentially reusable:
- Existing Godot 3D game/client structure.
- Third-person gameplay foundations and world interaction patterns.
- Existing multiplayer/netcode direction (Rust-based Sustenet project).
- Character, inventory/economy and content-system patterns where present in source.

Not reusable as-is:
- Reia's fantasy setting, lore, combat identity, progression and game balance.
- Its world/map/art assets without checking each asset's individual license and provenance.
- Its networking/security assumptions without an independent audit.
- Any mobile compatibility claim until an Android export is built and tested on real devices.

## Critical caveats

The README itself says the project is still being developed, identifies upcoming UI/map/quest/networking work, and says there is no announced alpha/beta date. The `mobile-game` topic is not proof of a working Android APK. Treat Reia as a promising existing game codebase, not a finished production-ready mobile MMORPG.

The repository's top-level LICENSE is linked from GitHub, but this audit does not yet pin the exact upstream commit or verify every nested dependency, submodule, Git LFS asset, Rust crate, and asset-specific license. No upstream code or assets are copied by this audit.

## Required gate before importing

1. Obtain and pin an exact upstream commit SHA.
2. Clone the complete repository including Git LFS and submodules.
3. Inspect the full LICENSE and all nested third-party notices.
4. Audit Godot project version, export presets, Android plugins, native Rust libraries and ABI support (especially arm64-v8a).
5. Build the unmodified upstream project for Android and test install/start/input/performance on a physical device.
6. Inventory gameplay systems and identify a minimal vertical slice that can be reskinned/reworked into Chișinău serious roleplay.
7. Only then vendor or fork the selected code, retaining notices and recording every imported path.

## Proposed Moldova conversion

- Replace fantasy world, story, NPCs and assets with an original Chișinău environment.
- Replace fantasy progression/combat with serious roleplay: identity, jobs, vehicles, property, economy in MDL, public services and player-run businesses.
- Preserve a server-authoritative architecture; do not trust client-side money, inventory, job rewards or property ownership.
- Keep Android touch controls as the primary input. Desktop keyboard support remains optional for development.

## Current decision

**Candidate selected for deeper technical validation; integration is NOT yet approved.**

Reason: Reia is closer to the requested 3D multiplayer game than a bare controller or framework, but its current public documentation does not prove a ready-to-ship Android game. Blindly copying it would risk importing unfinished systems and unverified assets/dependencies.
