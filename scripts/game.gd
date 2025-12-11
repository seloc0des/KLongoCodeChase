extends Node2D

@onready var player: Player = $Player
@onready var camera: Camera2D = $Camera2D
@onready var level_manager: LevelManager = $LevelManager
@onready var background: ParallaxBackground = $ParallaxBackground
@onready var hud: CanvasLayer = $HUD
@onready var pause_menu: Control = $PauseMenu
@onready var game_over_screen: Control = $GameOver

const PLAYER_SCREEN_X: float = 150.0  # Player stays at this X position on screen
const GROUND_Y: float = 1148.0  # Ground level for player


func _ready() -> void:
	# Initialize player position
	player.position = Vector2(PLAYER_SCREEN_X, GROUND_Y)
	
	# Set up camera
	camera.position = Vector2(360, 640)
	
	# Initialize level manager
	level_manager.initialize(camera)
	
	# Connect player signals
	player.died.connect(_on_player_died)
	
	# Start the game
	GameManager.start_game()
	
	# Play game music
	AudioManager.play_music("game_music")


func _process(delta: float) -> void:
	if GameManager.current_state == GameManager.GameState.PLAYING:
		_update_camera(delta)
		_update_parallax(delta)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		GameManager.toggle_pause()


func _update_camera(delta: float) -> void:
	# Move camera with game speed
	var speed = GameManager.get_effective_speed()
	camera.position.x += speed * delta
	
	# Keep player at constant screen position
	player.position.x = camera.position.x - 360 + PLAYER_SCREEN_X


func _update_parallax(_delta: float) -> void:
	if background and not GameManager.settings.get("reduced_motion", false):
		# Parallax is handled automatically by ParallaxBackground
		pass


func _on_player_died() -> void:
	# Stop camera movement (handled by GameManager state)
	AudioManager.stop_music()


func restart() -> void:
	# Reset everything
	player.reset()
	player.position = Vector2(PLAYER_SCREEN_X, GROUND_Y)
	camera.position = Vector2(360, 640)
	level_manager.reset()
	level_manager.initialize(camera)
	GameManager.start_game()
	AudioManager.play_music("game_music")


func _on_death_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()
