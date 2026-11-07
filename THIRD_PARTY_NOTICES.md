# Third-party notices

## Godot Engine
Godot Engine is MIT-licensed. Include the copyright and license text for the exact engine version used in distributed builds.

## Controller research and design reference
The mobile/third-person controller design was reviewed against:

- Repository: https://github.com/selgesel/godot4-third-person-controller
- Upstream commit reviewed: `c809ec20fd8170f4a81f3d8964e8a9838f8b29da`
- License: MIT
- Copyright: Copyright (c) 2021 Selgesel

The upstream project contains a larger player state machine and scene graph with dependencies on its own assets and scripts. Those files have **not** been copied into this repository. The current controller is a small project-specific implementation informed by the upstream control concepts; it is not a verbatim vendored copy.

## Multiplayer architecture research
- Repository: https://github.com/ekulbyrnes/saje
- License: MIT
- Copyright: Copyright (c) 2025 slayhorizon

SAJE is experimental. No SAJE source files are bundled in this repository yet. Its code, dependencies, security posture and asset licenses must be audited before selective reuse.

## Asset policy
No third-party 3D models, textures, audio, fonts or map datasets are bundled at this stage. Do not add an asset until its source, creator, exact license, attribution and redistribution rights are reviewed.
