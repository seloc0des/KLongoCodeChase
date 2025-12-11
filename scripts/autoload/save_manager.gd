extends Node

const SAVE_PATH = "user://save_data.json"

var save_data: Dictionary = {
	"total_orbs": 0,
	"high_score": 0,
	"best_distance": 0.0,
	"total_runs": 0,
	"total_distance": 0.0,
	"unlocked_skins": ["default"],
	"unlocked_trails": ["none"],
	"unlocked_themes": ["dark_mode"],
	"current_skin": "default",
	"current_trail": "none",
	"current_theme": "dark_mode",
	"settings": {
		"master_volume": 1.0,
		"music_volume": 0.8,
		"sfx_volume": 1.0,
		"colorblind_mode": false,
		"reduced_motion": false
	}
}


func _ready() -> void:
	load_game()


func save_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(save_data, "\t")
		file.store_string(json_string)
		file.close()
		print("Game saved successfully")


func load_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			var json = JSON.new()
			var error = json.parse(json_string)
			if error == OK:
				var loaded_data = json.get_data()
				# Merge loaded data with defaults (in case new fields were added)
				merge_save_data(loaded_data)
				print("Game loaded successfully")
			else:
				print("Error parsing save file: ", json.get_error_message())
	else:
		print("No save file found, using defaults")
		save_game()


func merge_save_data(loaded_data: Dictionary) -> void:
	for key in loaded_data.keys():
		if save_data.has(key):
			if typeof(save_data[key]) == TYPE_DICTIONARY and typeof(loaded_data[key]) == TYPE_DICTIONARY:
				for sub_key in loaded_data[key].keys():
					save_data[key][sub_key] = loaded_data[key][sub_key]
			else:
				save_data[key] = loaded_data[key]


func update_stats(score: int, distance: float, _orbs: int) -> void:
	save_data["total_runs"] += 1
	save_data["total_distance"] += distance
	
	if score > save_data["high_score"]:
		save_data["high_score"] = score
	
	if distance > save_data["best_distance"]:
		save_data["best_distance"] = distance
	
	save_game()


func add_orbs(amount: int) -> void:
	save_data["total_orbs"] += amount
	save_game()


func spend_orbs(amount: int) -> bool:
	if save_data["total_orbs"] >= amount:
		save_data["total_orbs"] -= amount
		save_game()
		return true
	return false


func get_total_orbs() -> int:
	return save_data["total_orbs"]


func get_high_score() -> int:
	return save_data["high_score"]


func get_best_distance() -> float:
	return save_data["best_distance"]


func unlock_item(item_type: String, item_name: String) -> void:
	var key = "unlocked_" + item_type
	if save_data.has(key) and item_name not in save_data[key]:
		save_data[key].append(item_name)
		save_game()


func is_item_unlocked(item_type: String, item_name: String) -> bool:
	var key = "unlocked_" + item_type
	return save_data.has(key) and item_name in save_data[key]


func set_current_item(item_type: String, item_name: String) -> void:
	var key = "current_" + item_type
	if save_data.has(key):
		save_data[key] = item_name
		save_game()


func get_current_item(item_type: String) -> String:
	var key = "current_" + item_type
	if save_data.has(key):
		return save_data[key]
	return ""


func update_setting(setting_name: String, value) -> void:
	if save_data["settings"].has(setting_name):
		save_data["settings"][setting_name] = value
		save_game()
		# Also update GameManager settings
		if GameManager.settings.has(setting_name):
			GameManager.settings[setting_name] = value


func get_setting(setting_name: String):
	if save_data["settings"].has(setting_name):
		return save_data["settings"][setting_name]
	return null


func reset_all_data() -> void:
	save_data = {
		"total_orbs": 0,
		"high_score": 0,
		"best_distance": 0.0,
		"total_runs": 0,
		"total_distance": 0.0,
		"unlocked_skins": ["default"],
		"unlocked_trails": ["none"],
		"unlocked_themes": ["dark_mode"],
		"current_skin": "default",
		"current_trail": "none",
		"current_theme": "dark_mode",
		"settings": {
			"master_volume": 1.0,
			"music_volume": 0.8,
			"sfx_volume": 1.0,
			"colorblind_mode": false,
			"reduced_motion": false
		}
	}
	save_game()
	print("All data reset")
