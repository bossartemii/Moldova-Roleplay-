# Open-source implementation stack

This project must reuse audited open-source components where they fit. Do not reimplement mature systems merely to claim originality.

## Selected upstream projects

### 1. Third-person and touchscreen controller
- Upstream: https://github.com/selgesel/godot4-third-person-controller
- License: MIT (verified from upstream LICENSE; copyright Selgesel, 2021).
- Fit: Godot 4 controller with touchscreen joystick/gesture support.
- Planned use: inspect and port the minimal player/camera/touch-control components into this project, preserving the upstream MIT notice. Adapt movement and UI for serious roleplay; do not import unrelated swimming mechanics without need.
- Status: selected for integration; not yet vendored or tested in this repository.

### 2. Multiplayer architecture and server framework reference
- Upstream: https://github.com/ekulbyrnes/saje
- License: MIT (verified from upstream LICENSE; copyright slayhorizon, 2025).
- Fit: Godot 4.4+ experimental open-source MMORPG framework with gateway/master/world-server separation, authentication, accounts, character creation, entity synchronization, instance chat and server-side NPCs.
- Planned use: evaluate and reuse compatible networking/server modules as the foundation for the persistent world. Replace fantasy RPG classes/combat and unsuitable game rules with Moldova Roleplay systems.
- Caution: upstream describes itself as experimental; its README lists interpolation and server-side anti-cheat as unfinished. It is not production-ready security by itself.
- Status: selected for deeper code/dependency audit; no upstream code copied yet.

### 3. Dedicated server separation example
- Upstream: https://github.com/SlayHorizon/godot-dedicated-server-example
- License: MIT (verified from upstream LICENSE; copyright slayhorizon, 2025).
- Fit: separate Godot client and dedicated-server projects, compatible with Godot 4.x–4.5 according to upstream README.
- Planned use: architectural reference if SAJE's server packaging needs separation.
- Status: reference only; no code copied.

## Integration rules

1. Verify the exact upstream commit, license, asset licenses, dependencies and security posture before copying code.
2. Keep each upstream LICENSE and required copyright/attribution notices.
3. Record imported files and source commit in THIRD_PARTY_NOTICES.md.
4. Do not import game art, maps, characters, audio or branding unless their individual licenses explicitly permit it.
5. Keep authoritative economy, inventory, jobs, property, moderation and anti-cheat validation on the server.
6. Do not describe the game as multiplayer, persistent or production-ready until those features are implemented and tested.
7. Prefer small, traceable integrations over copying entire repositories blindly.

## Product-specific systems to implement

Original Moldova Roleplay code will define the Chișinău map, MDL economy, Romanian/Italian/Russian/English localization, serious-RP rules, jobs, vehicles, property, legal system, moderation and progression.
