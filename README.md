# KLongo's Code Chase

A Geometry Dash-style **one-touch runner** about surviving a chaotic software development office as **KLongo**, a determined dev dodging meetings, bugs, and broken builds.

## 🎮 How to Play

1. **Open the project in Godot 4.x**
2. Press **F5** or click the Play button to run the game
3. **Tap/Click/Spacebar** to jump
4. **Hold** for a longer jump
5. Avoid obstacles: chairs, monitors, error logs, popups, and bugs
6. Collect **Focus Orbs** for currency
7. Grab power-ups:
   - ☕ **Coffee** - Slow motion effect
   - 🛡 **Bug Squash** - Shield (blocks one hit)
   - 🦆 **Rubber Duck** - Highlights upcoming hazards

## 🎯 Controls

| Action | Input |
|--------|-------|
| Jump | Tap / Click / Spacebar |
| Pause | Escape |

## 📁 Project Structure

```
KLongoCodeChase/
├── project.godot          # Godot project config
├── scenes/
│   ├── MainMenu.tscn      # Main menu
│   ├── Game.tscn          # Main game scene
│   ├── PlayerKLongo.tscn  # Player character
│   ├── ui/                # UI scenes (HUD, Pause, GameOver, Settings)
│   ├── level/             # Level segments (Easy, Medium, Hard)
│   ├── obstacles/         # Obstacle variants
│   └── pickups/           # Pickup items
└── scripts/
    ├── autoload/          # GameManager, SaveManager, AudioManager
    ├── game.gd            # Main game logic
    ├── player.gd          # Player movement & collision
    ├── level_manager.gd   # Procedural level generation
    ├── obstacle.gd        # Obstacle base class
    └── pickup.gd          # Pickup base class
```

## ✨ Features (Placeholder Version)

- [x] One-touch jump controls with coyote time & jump buffering
- [x] Auto-scrolling gameplay with increasing speed
- [x] Procedural level generation with difficulty tiers
- [x] 5 obstacle types with placeholder visuals
- [x] 4 pickup/power-up types
- [x] HUD with score, distance, orbs display
- [x] Pause menu with settings
- [x] Game over screen with high score tracking
- [x] Local save system (high scores, settings, unlocks)
- [x] Audio system with placeholder sounds
- [x] Accessibility options (colorblind mode, reduced motion)
- [x] Settings (volume controls, data reset)

## 🔊 Placeholder Audio

The game generates simple sine wave placeholder sounds:
- Jump, land, collect, powerup, hit, death effects
- Basic looping background music

These will be replaced with proper audio in the final version.

## 🎨 Placeholder Visuals

All visuals use simple colored rectangles and labels:
- **Blue rectangle** = KLongo (player)
- **Brown rectangle** = Chair obstacle
- **Gray rectangle** = Monitor obstacle  
- **Red triangle** = Error logs (spike)
- **White rectangle** = Popup window
- **Purple circle** = Bug (floating)
- **Green circle** = Focus Orb
- **Brown rectangle** = Coffee power-up
- **Green circle** = Bug Squash shield
- **Yellow circle** = Rubber Duck

## 🛠 Testing Notes

1. **Jump mechanics**: Test coyote time (can jump briefly after leaving ground)
2. **Jump buffering**: Press jump slightly before landing to auto-jump
3. **Difficulty scaling**: Speed increases over time, harder segments spawn later
4. **Power-ups**: 
   - Coffee slows game for 5 seconds
   - Bug Squash blocks one hit
   - Rubber Duck highlights obstacles for 8 seconds
5. **Save system**: High scores and settings persist between sessions

## 📝 Ethical Design

- No ads, no tracking, no analytics
- All progress saved locally
- No dark patterns or FOMO mechanics
- Short, meaningful runs (1-3 minutes)
- Cosmetic-only unlocks planned

## 🚀 Next Steps

After testing the placeholder version:
1. Replace ColorRect visuals with proper sprites
2. Add character animations
3. Replace placeholder audio with proper SFX/music
4. Add particle effects
5. Implement cosmetic shop
6. Polish UI with proper themes
7. Mobile touch optimization
8. Export for Android

---

**Engine:** Godot 4.x  
**Target:** Mobile (Android, Portrait 9:16)
