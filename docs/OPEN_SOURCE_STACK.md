# Open-source implementation stack

## Active runtime: Godot 4

Godot 4 is the active engine for this branch.

- Project: this repository's root `project.godot`
- Main scene: `scenes/main.tscn`
- Player prototype: `scripts/player.gd`
- Mobile HUD: `scripts/mobile_hud.gd`
- World greybox: `scripts/world.gd`
- Renderer: Compatibility / GL Compatibility, selected for broad mobile hardware support.

Godot is open source under the MIT license. Review the license for every external plugin, asset pack, font, sound and model added later; do not assume the engine license covers third-party content.

## References to evaluate, not blindly import

- Godot third-person controller: https://github.com/selgesel/godot4-third-person-controller
- SAJE: https://github.com/ekulbyrnes/saje
- Godot dedicated-server example: https://github.com/SlayHorizon/godot-dedicated-server-example

These are reference projects only until their current maintenance state, Godot compatibility, license, security and Android behavior are independently checked. Do not copy code or assets without preserving their license and attribution.

## Historical Unity experiment

The `vendor/SanAndreasUnity` submodule and Unity integration documents are retained for traceability. They are not loaded by the Godot project and are not part of the active runtime. Do not delete them as part of Godot development without a separate explicit decision.

## Architecture rules

1. Keep the Android client responsive and avoid expensive per-frame allocations.
2. Treat all client input as untrusted.
3. Keep money, inventory, jobs, property, rewards, moderation and player positions validated by the server.
4. Never trust client-reported currency, item ownership, damage or progression.
5. Pin exact revisions and audit licenses before adding external dependencies.
6. Use original or explicitly licensed game assets; GTA San Andreas assets are not open source.
7. Do not call the game multiplayer-ready, persistent or production-ready until those systems are implemented and tested.
