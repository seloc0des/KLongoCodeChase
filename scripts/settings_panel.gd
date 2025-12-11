extends Control

signal closed

@onready var master_slider: HSlider = $Panel/VBoxContainer/MasterVolume/Slider
@onready var music_slider: HSlider = $Panel/VBoxContainer/MusicVolume/Slider
@onready var sfx_slider: HSlider = $Panel/VBoxContainer/SFXVolume/Slider
@onready var colorblind_toggle: CheckButton = $Panel/VBoxContainer/ColorblindMode/Toggle
@onready var reduced_motion_toggle: CheckButton = $Panel/VBoxContainer/ReducedMotion/Toggle
@onready var reset_button: Button = $Panel/VBoxContainer/ResetButton
@onready var close_button: Button = $Panel/VBoxContainer/CloseButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Load current settings
	_load_settings()
	
	# Connect signals
	if master_slider:
		master_slider.value_changed.connect(_on_master_volume_changed)
	if music_slider:
		music_slider.value_changed.connect(_on_music_volume_changed)
	if sfx_slider:
		sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	if colorblind_toggle:
		colorblind_toggle.toggled.connect(_on_colorblind_toggled)
	if reduced_motion_toggle:
		reduced_motion_toggle.toggled.connect(_on_reduced_motion_toggled)
	if reset_button:
		reset_button.pressed.connect(_on_reset_pressed)
	if close_button:
		close_button.pressed.connect(_on_close_pressed)


func _load_settings() -> void:
	var master = SaveManager.get_setting("master_volume")
	var music = SaveManager.get_setting("music_volume")
	var sfx = SaveManager.get_setting("sfx_volume")
	var colorblind = SaveManager.get_setting("colorblind_mode")
	var reduced = SaveManager.get_setting("reduced_motion")
	
	if master_slider and master != null:
		master_slider.value = master
	if music_slider and music != null:
		music_slider.value = music
	if sfx_slider and sfx != null:
		sfx_slider.value = sfx
	if colorblind_toggle and colorblind != null:
		colorblind_toggle.button_pressed = colorblind
	if reduced_motion_toggle and reduced != null:
		reduced_motion_toggle.button_pressed = reduced


func _on_master_volume_changed(value: float) -> void:
	AudioManager.set_master_volume(value)
	SaveManager.update_setting("master_volume", value)


func _on_music_volume_changed(value: float) -> void:
	AudioManager.set_music_volume(value)
	SaveManager.update_setting("music_volume", value)


func _on_sfx_volume_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)
	SaveManager.update_setting("sfx_volume", value)
	AudioManager.play_sfx("button")  # Preview sound


func _on_colorblind_toggled(pressed: bool) -> void:
	SaveManager.update_setting("colorblind_mode", pressed)
	GameManager.settings["colorblind_mode"] = pressed


func _on_reduced_motion_toggled(pressed: bool) -> void:
	SaveManager.update_setting("reduced_motion", pressed)
	GameManager.settings["reduced_motion"] = pressed


func _on_reset_pressed() -> void:
	AudioManager.play_sfx("button")
	SaveManager.reset_all_data()
	_load_settings()


func _on_close_pressed() -> void:
	AudioManager.play_sfx("button")
	visible = false
	closed.emit()
