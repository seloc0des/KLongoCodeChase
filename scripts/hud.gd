extends CanvasLayer

@onready var score_label: Label = $TopBar/ScoreContainer/ScoreLabel
@onready var distance_label: Label = $TopBar/DistanceContainer/DistanceLabel
@onready var orbs_label: Label = $TopBar/OrbsContainer/OrbsLabel
@onready var pause_button: Button = $TopBar/PauseButton
@onready var powerup_container: HBoxContainer = $PowerupContainer
@onready var coffee_indicator: ColorRect = $PowerupContainer/CoffeeIndicator
@onready var bug_squash_indicator: ColorRect = $PowerupContainer/BugSquashIndicator
@onready var duck_indicator: ColorRect = $PowerupContainer/DuckIndicator


func _ready() -> void:
	# Connect to game signals
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.orbs_changed.connect(_on_orbs_changed)
	GameManager.powerup_activated.connect(_on_powerup_activated)
	GameManager.powerup_deactivated.connect(_on_powerup_deactivated)
	
	# Connect pause button
	if pause_button:
		pause_button.pressed.connect(_on_pause_pressed)
	
	# Initialize display
	_reset_display()


func _process(_delta: float) -> void:
	if GameManager.current_state == GameManager.GameState.PLAYING:
		_update_distance()


func _reset_display() -> void:
	if score_label:
		score_label.text = "0"
	if distance_label:
		distance_label.text = "0m"
	if orbs_label:
		orbs_label.text = "0"
	
	# Hide all powerup indicators
	if coffee_indicator:
		coffee_indicator.visible = false
	if bug_squash_indicator:
		bug_squash_indicator.visible = false
	if duck_indicator:
		duck_indicator.visible = false


func _on_score_changed(new_score: int) -> void:
	if score_label:
		score_label.text = str(new_score)


func _on_orbs_changed(new_orbs: int) -> void:
	if orbs_label:
		orbs_label.text = str(new_orbs)


func _update_distance() -> void:
	if distance_label:
		distance_label.text = "%.0fm" % GameManager.distance


func _on_powerup_activated(powerup_type: String) -> void:
	match powerup_type:
		"coffee":
			if coffee_indicator:
				coffee_indicator.visible = true
		"bug_squash":
			if bug_squash_indicator:
				bug_squash_indicator.visible = true
		"rubber_duck":
			if duck_indicator:
				duck_indicator.visible = true


func _on_powerup_deactivated(powerup_type: String) -> void:
	match powerup_type:
		"coffee":
			if coffee_indicator:
				coffee_indicator.visible = false
		"bug_squash":
			if bug_squash_indicator:
				bug_squash_indicator.visible = false
		"rubber_duck":
			if duck_indicator:
				duck_indicator.visible = false


func _on_pause_pressed() -> void:
	AudioManager.play_sfx("button")
	GameManager.pause_game()
