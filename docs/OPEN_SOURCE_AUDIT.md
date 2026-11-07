# Open-source audit — 2026-11-07

## DevanMetz/openrp
- License file inspected: MIT, copyright 2026 Devan Metz.
- Browser-first Three.js/TypeScript multiplayer sandbox with persistence and roleplay systems.
- Not an Android-native Godot client; alpha notes indicate it is not load-tested for a large hostile public server.
- Decision: reference architecture only; no code/assets copied.

## orion3dgames/t5c
- package.json inspected: MIT declared; Babylon.js 8.28.3 and Colyseus 0.15 dependencies.
- Web 3D RPG example with server/client split, inventory and load-test script.
- Older Colyseus 0.15 dependency family; requires a complete dependency/SBOM/security review before reuse.
- Decision: reference only; no code/assets copied.

## Asset rules
No ripped GTA/SA-MP assets, commercial game assets, music, logos or map meshes. Every external asset must have source, creator, exact license and attribution recorded. OpenStreetMap-derived data requires ODbL review and attribution.

## Limitations
This is a preliminary repository/license screening, not legal advice, a full transitive dependency audit, malware scan, build or load test.
