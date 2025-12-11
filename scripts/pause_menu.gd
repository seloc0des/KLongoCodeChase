extends Control

# signal closed  # Reserved for future use

@onready var resume_button: Button = $Panel/VBoxContainer/ResumeButton
@onready var restart_button: Button = $Panel/VBoxContainer/RestartButton
@onready var settings_button: Button = $Panel/VBoxContainer/SettingsButton
@onready var menu_button: Button = $Panel/VBoxContainer/MenuButton
@onready var settings_panel: Control = $SettingsPanel


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Connect button signals
	if resume_button:
		resume_button.pressed.connect(_on_resume_pressed)
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)
	if settings_button:
		settings_button.pressed.connect(_on_settings_pressed)
	if menu_button:
		menu_button.pressed.connect(_on_menu_pressed)
	
	# Hide settings panel initially
	if settings_panel:
		settings_panel.visible = false
	
	# Connect to game signals
	GameManager.game_paused.connect(_on_game_paused)
	GameManager.game_resumed.connect(_on_game_resumed)
	
	# Start hidden
	visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and visible:
		_on_resume_pressed()


func _on_game_paused() -> void:
	visible = true


func _on_game_resumed() -> void:
	visible = false
	if settings_panel:
		settings_panel.visible = false


func _on_resume_pressed() -> void:
	AudioManager.play_sfx("button")
	GameManager.resume_game()


func _on_restart_pressed() -> void:
	AudioManager.play_sfx("button")
	GameManager.restart_game()


func _on_settings_pressed() -> void:
	AudioManager.play_sfx("button")
	if settings_panel:
		settings_panel.visible = true


func _on_menu_pressed() -> void:
	AudioManager.play_sfx("button")
	GameManager.go_to_menu()


func _on_settings_closed() -> void:
	if settings_panel:
		settings_panel.visible = false
