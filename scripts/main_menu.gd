extends Control

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var quit_button: Button = $VBoxContainer/QuitButton
@onready var high_score_label: Label = $StatsContainer/HighScoreLabel
@onready var best_distance_label: Label = $StatsContainer/BestDistanceLabel
@onready var total_orbs_label: Label = $StatsContainer/TotalOrbsLabel
@onready var settings_panel: Control = $SettingsPanel


func _ready() -> void:
	# Connect button signals
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# Update stats display
	_update_stats_display()
	
	# Hide settings panel initially
	if settings_panel:
		settings_panel.visible = false
	
	# Play menu music
	AudioManager.play_music("menu_music")
	
	# Play button sound on focus
	for button in [play_button, settings_button, quit_button]:
		if button:
			button.mouse_entered.connect(_on_button_hover)


func _update_stats_display() -> void:
	if high_score_label:
		high_score_label.text = "High Score: %d" % SaveManager.get_high_score()
	if best_distance_label:
		best_distance_label.text = "Best Distance: %.0fm" % SaveManager.get_best_distance()
	if total_orbs_label:
		total_orbs_label.text = "Total Orbs: %d" % SaveManager.get_total_orbs()


func _on_play_pressed() -> void:
	AudioManager.play_sfx("button")
	get_tree().change_scene_to_file("res://scenes/Game.tscn")


func _on_settings_pressed() -> void:
	AudioManager.play_sfx("button")
	if settings_panel:
		settings_panel.visible = true


func _on_quit_pressed() -> void:
	AudioManager.play_sfx("button")
	get_tree().quit()


func _on_button_hover() -> void:
	AudioManager.play_sfx("button")


func _on_settings_closed() -> void:
	if settings_panel:
		settings_panel.visible = false
	_update_stats_display()
