# Gameplay Slice 01 — Chișinău street blockout

## Implemented in this slice

- Expanded the procedural greybox with boulevard sidewalks, lane markings, apartment facades, trees and street furniture.
- Added two world information points: a bus-stop information sign and a municipal information board.
- Added a camera-centred interaction raycast to the player controller.
- Added a context-sensitive **USA** touch action when an interactable object is in view.
- Resized the virtual joystick and action buttons from the current viewport dimensions.
- Avoided redrawing the complete HUD every frame when its visible state has not changed.

## How to test in Godot

1. Open the project with Godot 4.4 or a compatible Godot 4 release.
2. Run `scenes/main.tscn`.
3. Move forward from the spawn point towards the blue bus-stop sign.
4. Aim the camera at the sign from close range. The interaction prompt should appear near the top of the screen.
5. Tap **USA**. The information message should appear below the game title.
6. Repeat at the municipal information board in the civic square.
7. Resize the game window or test a portrait viewport to inspect the touch control layout.

## Validation status

This slice has been committed to GitHub, but it has **not** been run in the Godot editor or on a physical Android device in this workflow. The steps above are a test plan, not a claim that the tests passed.

## Known limitations

- Buildings and city props are original procedural blockout geometry, not final Chișinău assets.
- Bus route text is fictional demo content, not live public transport data.
- Interactions currently display local messages only; there is no quest state, server authority, or persistence yet.
- Touch layout and raycast distance need real-device tuning.
- No Android APK has been exported from this slice.
