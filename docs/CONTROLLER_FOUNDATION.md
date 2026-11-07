# Controller foundation — integration record

## Scope
This change establishes a usable baseline for keyboard, gamepad-compatible InputMap actions and touch controls on the existing prototype. It does not claim a complete character controller or a finished Android build.

## Changes
- Added named gameplay actions for forward/back/left/right, jump and sprint.
- Switched the Android orientation to landscape for a third-person open-world layout.
- Made player movement camera-relative: joystick direction follows the camera yaw.
- Added ground/air acceleration and keyboard sprint/jump.
- Kept the existing mobile HUD API (`set_mobile_move`, `set_mobile_sprint`, `request_jump`, `rotate_camera`) compatible.

## Open-source review
The MIT project `selgesel/godot4-third-person-controller` was inspected at commit `c809ec20fd8170f4a81f3d8964e8a9838f8b29da`. Its full player controller depends on a larger state machine, scene graph, animation assets and water systems, so copying only its `Player.gd` would break this project. We are adopting the relevant input/camera control patterns rather than importing an incomplete dependency graph.

SAJE remains an architecture candidate only. It is explicitly experimental and its README lists entity interpolation and server-side anti-cheat as unfinished. No multiplayer code is claimed as implemented.

## Verification status
- Repository source reviewed through GitHub.
- Runtime import, GDScript parse, Android export and on-device input tests: **not run** (no Godot runtime/device build was available in this workflow).
- Next gate: open the project in Godot 4.4, run the main scene, inspect parser output, then test touch input on Android before merging.
