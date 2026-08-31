# Untitled Speedster Stealth Game

Imagine Payday 2, but you're a Speedster.

<img width="800" height="450" alt="U_S_S_G_Short_video-ezgif com-video-to-gif-converter" src="https://github.com/user-attachments/assets/80349a89-0278-4802-b651-15bf38580c68" />

## Status

Greybox prototype playable. Built in Godot 4.7.

Movement and trail-effect (TO BE IMPLEMENTED) systems carried over from
[Race Against the Clock](https://github.com/voidprophet/race-against-the-clock).

## The core mechanic

Hold shift to spend stamina and ramp into slow time. Release, and you coast at
whatever depth you reached while stamina bleeds away far more slowly. Ctrl sheds
depth, which cuts the drain rate. Going deep costs most of your stamina to get there and buys
you a couple of seconds. A light slow costs much less and lasts fifteen or more.

## Implemented

- Depth-based time slow with charge, sustain, brake, and collapse states
- Stamina bank with upfront cost, depth-scaled sustain drain, and delayed regen
- Soft landing: depth holds briefly at zero stamina, then eases out
- Third-person camera
- Guard line-of-sight detection with a fill and decay meter

## Known limitations

Slow-motion currently drives `Engine.time_scale`, which inflates the physics tick
rate and runs into Godot's `max_physics_steps_per_frame` clamp below roughly 0.07.
Past that point the world runs slower than configured and the depth becomes
frame-rate dependent. Planned fix is a per-entity time scaling system so the
player runs at real time while the world is scaled independently, which removes
the physics cost entirely.
