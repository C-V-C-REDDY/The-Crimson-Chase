# The Crimson Chase

> Survive the maze. Complete the mission. Outrun what cannot be stopped.


**Genre:** Dark Fantasy Survival
**Engine:** Godot 4
**Platform:** PC (Web build on itch.io)
**Status:** Shipped — V3
**Play:** [cvcreddy.itch.io/the-crimson-chase](https://cvcreddy.itch.io/the-crimson-chase)

---

## Overview

The Crimson Chase is a top-down dark fantasy survival game set in a cursed maze.
Navigate the darkness, collect keys, charge ancient checkpoints, and survive
long enough to face what cannot be stopped.

---

## Gameplay

### Mission 1 — The Hunt
Collect 5 keys AND charge 5 checkpoints before 150 seconds run out.
The maze is wide. Berserk is patient. Plan your route carefully.

### Mission 2 — He is Unleashed.
The SafeZone is gone. Berserk is faster.
Your only survival tool is the EmberPooring stealth buff.
Survive 30 seconds.

---

## Features

- **FSM AI** — Berserk runs a 3-state finite state machine: PATROLLING → CHASING → RETREATING
- **FOV Cone Detection** — Berserk detects the player within a vision cone via RayCast2D
- **Checkpoint Patrol** — Berserk patrols 9 waypoints across the 6400×4496 world
- **Bell Traps** — Invisible trigger zones that teleport Berserk to the player's location
- **Ancient Checkpoints** — Stand still for 3 seconds to charge, visible progress bar
- **EmberPooring Loot** — Collectible that reduces skill cooldown
- **Dynamic BGM** — Music shifts on Boss Mode trigger with Tween crossfade
- **Minimap** — Live world overview with no Berserk dot — you never know where he is
- **Mission Manager** — Autoload that controls HUNT → TRANSITION → BOSS → END phases
- **Cinematic Transition** — 5 second pause, double red flash, "He is Unleashed." before Boss Mode
- **Lives System** — 3 lives, game over on depletion

---

## Architecture
MissionManager (AutoLoad)   — phase control, timers, signals
Global (AutoLoad)           — shared state (keys, checkpoints, lives)
AudioManager (AutoLoad)     — SFX and BGM with crossfade
Berserk (CharacterBody2D)   — FSM, FOV cone, patrol, bell trap response
Player (CharacterBody2D)    — movement, skill system, SafeZone interaction
BellTrap (Area2D)           — one-use trigger, summons Berserk
Checkpoint (Area2D)         — 3s charge mechanic, progress bar
Minimap (CanvasLayer)       — viewport-based world overview

---

## Development

| Version | Highlights |
|---|---|
| V1 | Core loop, Mage, Pooring, Berserk AI, SafeZone, EmberPooring |
| V2 | Bigger maze, wall-immune Berserk, Warning Boards, refined loop |
| V3 | FSM, FOV cone, Bell Traps, Checkpoints, Mission Manager, Boss Mode |

---

## Controls

| Input | Action |
|---|---|
| Arrow Keys | Move |
| Auto | Skill activates on EmberPooring collect |

---

## Built By

**C.V.C.Reddy** — 3rd year B.Tech AIML student, self-directing a game development career.
Building a portfolio of Godot and Unity projects toward a junior game developer role.

[itch.io](https://cvcreddy.itch.io) · [LinkedIn](https://www.linkedin.com/in/c-8748483a8/) · [GitHub](https://github.com/C-V-C-REDDY)
