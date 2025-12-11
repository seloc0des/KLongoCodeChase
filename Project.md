# KLongo’s Code Chase

A Geometry Dash–style **one-touch runner** about surviving a chaotic software development office as **KLongo**, a determined dev dodging meetings, bugs, and broken builds.

This README is meant to be dropped straight into your repo as a starting point while you build the project in **Godot (4.x)**.

---

## 📱 Core Info

- **Game Name:** KLongo’s Code Commute  
- **Main Character:** KLongo  
- **Genre:** 2D auto-runner / rhythm platformer (Geometry Dash–inspired)  
- **Theme:** Software development in a modern office  
- **Target Platform:** Mobile (Android first, portrait)  
- **Aspect Ratio:** 9:16 (e.g., 720×1280 or 1080×1920)  
- **Engine:** Godot 4.x (GDScript)

---

## 🎮 High-Level Concept

The player auto-runs through an endless office corridor as **KLongo**.  
You tap to jump over **dev/office-themed obstacles**:

- Rolling office chairs  
- Piles of error logs (spikes)  
- Falling monitors  
- Pop-up windows  
- Bug icons floating like saws  

Along the way, you collect **Focus Orbs** and occasional power-ups like **Coffee Boost** (slow-mo), **Bug Squash tokens**, and **Rubber Duck insight**.

The goal: survive “sprints” of increasing difficulty, unlock cosmetics, and enjoy tight, skill-based runs that respect the player’s time and attention.

---

## 🧠 Ethical Design Principles

This project is intentionally designed with **ethical dopamine** and **no data harvesting**:

- No dark patterns, no lootboxes.  
- No tracking or analytics SDKs.  
- All progress saved **locally**; player can reset data at any time.  
- Short, meaningful runs (about 1–3 minutes).  
- Optional daily-style objectives, but **no streak punishment** or FOMO.  

The meta-progression focuses on **cosmetic unlocks** and **skill mastery**, not compulsion loops.

---

## ✨ Key Features (Planned)

- **One-touch controls**  
  - Tap to jump  
  - Optional: hold for longer jump duration  

- **Auto-run gameplay**  
  - Player constantly moves to the right  
  - Increasing speed over time for difficulty ramp

- **Office Dev Theme**  
  - Background: open-plan office (cubicles, whiteboards, monitors, server racks)  
  - Obstacles: meeting doors, chairs, monitors, coffee spills, bug icons, deploy warnings  
  - Visual “sprint markers” to show progress (e.g., sprint boards on walls)

- **Semi-randomized levels**  
  - Pre-built **LevelSegment** chunks stitched together at runtime  
  - Difficulty tiers (easy/medium/hard segments) based on time/distance

- **Power-ups & pickups**  
  - Focus Orbs (soft currency for cosmetics)  
  - Coffee Boost (temporary slow motion)  
  - Bug Squash token (forgives next mistake)  
  - Rubber Duck (highlights upcoming hazards)

- **Cosmetics & Unlocks**  
  - Skins for KLongo (hoodies, jackets, etc.)  
  - Particle trails (binary code, sticky notes, sparks)  
  - Color themes (Dark Mode, Sunset Office, Neon Ops)

- **Accessibility options**  
  - Colorblind-friendly hazard outlines  
  - Reduced motion (less parallax / screenshake)  
  - Adjustable sound/music volumes

---

## 🧱 Planned Project Structure (Godot)

> This is a suggested layout to help you start wiring scenes/scripts.

```text
project_root/
├─ README.md
├─ project.godot
├─ assets/
│  ├─ art/
│  │  ├─ characters/
│  │  ├─ obstacles/
│  │  └─ backgrounds/
│  ├─ audio/
│  │  ├─ music/
│  │  └─ sfx/
│  └─ fonts/
├─ scenes/
│  ├─ MainMenu.tscn
│  ├─ Game.tscn
│  ├─ PlayerKLongo.tscn
│  ├─ ui/
│  │  ├─ HUD.tscn
│  │  └─ PauseMenu.tscn
│  ├─ level/
│  │  ├─ LevelManager.tscn
│  │  ├─ LevelSegment_Base.tscn
│  │  ├─ LevelSegment_Easy_01.tscn
│  │  ├─ LevelSegment_Med_01.tscn
│  │  └─ LevelSegment_Hard_01.tscn
│  ├─ obstacles/
│  │  ├─ Obstacle_Base.tscn
│  │  ├─ Obstacle_Chair.tscn
│  │  ├─ Obstacle_Monitor.tscn
│  │  ├─ Obstacle_ErrorLogs.tscn
│  │  └─ Obstacle_Popup.tscn
│  └─ pickups/
│     ├─ Pickup_FocusOrb.tscn
│     ├─ Pickup_Coffee.tscn
│     ├─ Pickup_BugSquash.tscn
│     └─ Pickup_RubberDuck.tscn
├─ scripts/
│  ├─ main_menu.gd
│  ├─ game.gd
│  ├─ player_k-longo.gd
│  ├─ hud.gd
│  ├─ level_manager.gd
│  ├─ level_segment.gd
│  ├─ obstacle.gd
│  ├─ pickup.gd
│  └─ save_manager.gd
└─ data/
   └─ settings.cfg
