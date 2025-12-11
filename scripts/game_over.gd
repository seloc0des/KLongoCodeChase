extends CanvasLayer

@onready var container: Control = $Container
@onready var final_score_label: Label = $Container/Panel/VBoxContainer/FinalScoreLabel
@onready var final_distance_label: Label = $Container/Panel/VBoxContainer/FinalDistanceLabel
@onready var orbs_collected_label: Label = $Container/Panel/VBoxContainer/OrbsCollectedLabel
@onready var new_high_score_label: Label = $Container/Panel/VBoxContainer/NewHighScoreLabel
@onready var retry_button: Button = $Container/Panel/VBoxContainer/RetryButton
@onready var menu_button: Button = $Container/Panel/VBoxContainer/MenuButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Connect button signals
	if retry_button:
		retry_button.pressed.connect(_on_retry_pressed)
	if menu_button:
		menu_button.pressed.connect(_on_menu_pressed)
	
	# Connect to game over signal
	GameManager.game_over.connect(_on_game_over)
	print("GameOver: Connected to GameManager.game_over signal")
	
	# Start hidden
	container.visible = false


func _on_game_over(score: int, distance: float) -> void:
	print("GameOver._on_game_over received - score: ", score, " distance: ", distance)
	container.visible = true
	print("GameOver screen visible set to: ", container.visible)
	
	# Update labels
	if final_score_label:
		final_score_label.text = "Score: %d" % score
	if final_distance_label:
		final_distance_label.text = "Distance: %.0fm" % distance
	if orbs_collected_label:
		orbs_collected_label.text = "Orbs: %d" % GameManager.orbs_collected
	
	# Check for new high score
	if new_high_score_label:
		if score >= SaveManager.get_high_score():
			new_high_score_label.visible = true
			new_high_score_label.text = "🏆 NEW HIGH SCORE! 🏆"
		else:
			new_high_score_label.visible = false


func _on_retry_pressed() -> void:
	AudioManager.play_sfx("button")
	container.visible = false
	GameManager.restart_game()


func _on_menu_pressed() -> void:
	AudioManager.play_sfx("button")
	container.visible = false
	GameManager.go_to_menu()
