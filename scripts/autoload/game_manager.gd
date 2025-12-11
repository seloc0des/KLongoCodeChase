extends Node

signal game_started
signal game_over(score: int, distance: float)
signal game_paused
signal game_resumed
signal score_changed(new_score: int)
signal orbs_changed(new_orbs: int)
signal powerup_activated(powerup_type: String)
signal powerup_deactivated(powerup_type: String)

enum GameState { MENU, PLAYING, PAUSED, GAME_OVER }

var current_state: GameState = GameState.MENU
var score: int = 0
var distance: float = 0.0
var orbs_collected: int = 0
var current_speed: float = 300.0
var base_speed: float = 300.0
var max_speed: float = 600.0
var speed_increase_rate: float = 5.0

# Power-up states
var has_bug_squash: bool = false
var coffee_boost_active: bool = false
var rubber_duck_active: bool = false

# Difficulty
var difficulty_tier: int = 0  # 0=easy, 1=medium, 2=hard
var distance_thresholds: Array[float] = [500.0, 1500.0, 3000.0]

# Settings
var settings: Dictionary = {
	"master_volume": 1.0,
	"music_volume": 0.8,
	"sfx_volume": 1.0,
	"colorblind_mode": false,
	"reduced_motion": false
}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func start_game() -> void:
	reset_run()
	current_state = GameState.PLAYING
	game_started.emit()


func reset_run() -> void:
	score = 0
	distance = 0.0
	orbs_collected = 0
	current_speed = base_speed
	difficulty_tier = 0
	has_bug_squash = false
	coffee_boost_active = false
	rubber_duck_active = false


func end_game() -> void:
	current_state = GameState.GAME_OVER
	game_over.emit(score, distance)
	SaveManager.update_stats(score, distance, orbs_collected)


func pause_game() -> void:
	if current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
		get_tree().paused = true
		game_paused.emit()


func resume_game() -> void:
	if current_state == GameState.PAUSED:
		current_state = GameState.PLAYING
		get_tree().paused = false
		game_resumed.emit()


func toggle_pause() -> void:
	if current_state == GameState.PLAYING:
		pause_game()
	elif current_state == GameState.PAUSED:
		resume_game()


func go_to_menu() -> void:
	current_state = GameState.MENU
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func restart_game() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Game.tscn")


func _process(delta: float) -> void:
	if current_state == GameState.PLAYING:
		# Update distance
		distance += current_speed * delta
		
		# Increase speed over time
		if current_speed < max_speed:
			current_speed += speed_increase_rate * delta
			current_speed = min(current_speed, max_speed)
		
		# Update difficulty tier based on distance
		update_difficulty()
		
		# Update score based on distance
		var new_score = int(distance / 10.0)
		if new_score != score:
			score = new_score
			score_changed.emit(score)


func update_difficulty() -> void:
	var new_tier = 0
	for i in range(distance_thresholds.size()):
		if distance >= distance_thresholds[i]:
			new_tier = i + 1
	
	if new_tier != difficulty_tier:
		difficulty_tier = new_tier
		print("Difficulty increased to tier: ", difficulty_tier)


func add_orbs(amount: int) -> void:
	orbs_collected += amount
	orbs_changed.emit(orbs_collected)
	SaveManager.add_orbs(amount)


func activate_powerup(powerup_type: String) -> void:
	match powerup_type:
		"coffee":
			coffee_boost_active = true
			current_speed *= 0.5  # Slow motion effect
			powerup_activated.emit("coffee")
			# Deactivate after duration
			get_tree().create_timer(5.0).timeout.connect(_deactivate_coffee)
		"bug_squash":
			has_bug_squash = true
			powerup_activated.emit("bug_squash")
		"rubber_duck":
			rubber_duck_active = true
			powerup_activated.emit("rubber_duck")
			get_tree().create_timer(8.0).timeout.connect(_deactivate_rubber_duck)


func _deactivate_coffee() -> void:
	if coffee_boost_active:
		coffee_boost_active = false
		current_speed *= 2.0  # Restore speed
		powerup_deactivated.emit("coffee")


func _deactivate_rubber_duck() -> void:
	rubber_duck_active = false
	powerup_deactivated.emit("rubber_duck")


func use_bug_squash() -> bool:
	if has_bug_squash:
		has_bug_squash = false
		powerup_deactivated.emit("bug_squash")
		return true
	return false


func get_effective_speed() -> float:
	return current_speed
