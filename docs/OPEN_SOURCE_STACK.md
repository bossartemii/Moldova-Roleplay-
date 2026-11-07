# Open-source implementation stack

## Active engine direction

**SanAndreasUnity** is the selected legacy engine candidate for evaluation.

- Upstream: https://github.com/in0finite/SanAndreasUnity
- Pinned commit: `f685c437f48721afc0787f27d22c85d96e8684c7`
- Integration: Git submodule at `vendor/SanAndreasUnity`
- Upstream top-level license: MIT
- Audit: [SANANDREASUNITY_INTEGRATION.md](SANANDREASUNITY_INTEGRATION.md)

This is not yet approved for release. The pinned upstream is from 2022, uses Unity 2020.3.26f1, and its Android settings select ARMv7 only with old SDK levels. Nested submodule license gaps and prebuilt DLL provenance remain open. Do not upgrade, ship or expose a public server until the audit gates are completed.

## Legacy research (not the active runtime)

The earlier Godot research remains documented for history, but it is superseded by the Unity direction:
- Godot third-person controller: https://github.com/selgesel/godot4-third-person-controller
- SAJE framework: https://github.com/ekulbyrnes/saje
- Godot dedicated-server example: https://github.com/SlayHorizon/godot-dedicated-server-example

These repositories are not integrated into the active Unity runtime. Do not mix Godot scripts or dependencies into SanAndreasUnity.

## Integration rules

1. Pin exact commits for every upstream repository and nested submodule.
2. Keep each applicable license and attribution notice; never infer that one repository's license covers its submodules.
3. Verify source provenance, binary dependencies and redistribution rights before shipping.
4. Do not import copyrighted game maps, models, textures, audio, characters or branding without explicit rights.
5. Keep economy, inventory, jobs, property, rewards and moderation authoritative on the server.
6. Never describe a feature as implemented, multiplayer-ready or production-ready until it exists and has been tested.
7. Prefer traceable Git submodules or small audited changes over blind repository copying.
