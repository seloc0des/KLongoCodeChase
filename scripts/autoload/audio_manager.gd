extends Node

# Audio bus indices
var master_bus_idx: int
var music_bus_idx: int
var sfx_bus_idx: int

# Current music player
var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
const MAX_SFX_PLAYERS = 8

# Placeholder audio (will be replaced with actual sounds)
var placeholder_sounds: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Get audio bus indices
	master_bus_idx = AudioServer.get_bus_index("Master")
	
	# Create Music and SFX buses if they don't exist
	_setup_audio_buses()
	
	# Create music player
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	# Create SFX player pool
	for i in range(MAX_SFX_PLAYERS):
		var player = AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		sfx_players.append(player)
	
	# Apply saved settings
	_apply_saved_volumes()
	
	# Generate placeholder sounds
	_generate_placeholder_sounds()


func _setup_audio_buses() -> void:
	# Check if buses exist, create if not
	if AudioServer.get_bus_index("Music") == -1:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.bus_count - 1, "Music")
	
	if AudioServer.get_bus_index("SFX") == -1:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.bus_count - 1, "SFX")
	
	music_bus_idx = AudioServer.get_bus_index("Music")
	sfx_bus_idx = AudioServer.get_bus_index("SFX")


func _apply_saved_volumes() -> void:
	set_master_volume(SaveManager.get_setting("master_volume"))
	set_music_volume(SaveManager.get_setting("music_volume"))
	set_sfx_volume(SaveManager.get_setting("sfx_volume"))


func _generate_placeholder_sounds() -> void:
	# Generate simple placeholder sounds using AudioStreamGenerator
	# These are basic beeps/tones for testing
	placeholder_sounds = {
		"jump": _create_placeholder_tone(440.0, 0.1),      # A4 note, short
		"land": _create_placeholder_tone(220.0, 0.05),     # A3 note, very short
		"collect_orb": _create_placeholder_tone(880.0, 0.15),  # A5 note
		"powerup": _create_placeholder_tone(660.0, 0.3),    # E5 note, longer
		"hit": _create_placeholder_tone(150.0, 0.2),        # Low tone
		"death": _create_placeholder_tone(100.0, 0.5),      # Very low, long
		"button": _create_placeholder_tone(550.0, 0.08),    # Button click
		"menu_music": _create_placeholder_loop(0.5),        # Looping tone
		"game_music": _create_placeholder_loop(0.3),        # Faster loop
	}


func _create_placeholder_tone(frequency: float, duration: float) -> AudioStreamWAV:
	var sample_rate = 44100
	var samples = int(sample_rate * duration)
	var audio = AudioStreamWAV.new()
	audio.format = AudioStreamWAV.FORMAT_16_BITS
	audio.mix_rate = sample_rate
	audio.stereo = false
	
	var data = PackedByteArray()
	data.resize(samples * 2)
	
	for i in range(samples):
		var t = float(i) / sample_rate
		# Simple sine wave with fade out
		var envelope = 1.0 - (float(i) / samples)
		var sample = sin(2.0 * PI * frequency * t) * envelope * 0.5
		var sample_int = int(sample * 32767)
		data[i * 2] = sample_int & 0xFF
		data[i * 2 + 1] = (sample_int >> 8) & 0xFF
	
	audio.data = data
	return audio


func _create_placeholder_loop(beat_interval: float) -> AudioStreamWAV:
	var sample_rate = 44100
	var duration = 4.0  # 4 second loop
	var samples = int(sample_rate * duration)
	var audio = AudioStreamWAV.new()
	audio.format = AudioStreamWAV.FORMAT_16_BITS
	audio.mix_rate = sample_rate
	audio.stereo = false
	audio.loop_mode = AudioStreamWAV.LOOP_FORWARD
	audio.loop_begin = 0
	audio.loop_end = samples
	
	var data = PackedByteArray()
	data.resize(samples * 2)
	
	var frequencies = [262.0, 330.0, 392.0, 330.0]  # C, E, G, E chord progression
	var note_index = 0
	
	for i in range(samples):
		var t = float(i) / sample_rate
		var beat_position = fmod(t, beat_interval)
		
		# Change note every beat
		note_index = int(t / beat_interval) % frequencies.size()
		var freq = frequencies[note_index]
		
		# Envelope for each beat
		var envelope = max(0.0, 1.0 - (beat_position / beat_interval) * 2.0)
		var sample = sin(2.0 * PI * freq * t) * envelope * 0.3
		var sample_int = int(sample * 32767)
		data[i * 2] = sample_int & 0xFF
		data[i * 2 + 1] = (sample_int >> 8) & 0xFF
	
	audio.data = data
	return audio


func play_sfx(sound_name: String) -> void:
	var stream = placeholder_sounds.get(sound_name)
	if stream:
		# Find available player
		for player in sfx_players:
			if not player.playing:
				player.stream = stream
				player.play()
				return
		# If all players busy, use first one
		sfx_players[0].stream = stream
		sfx_players[0].play()


func play_music(music_name: String) -> void:
	var stream = placeholder_sounds.get(music_name)
	if stream:
		music_player.stream = stream
		music_player.play()


func stop_music() -> void:
	music_player.stop()


func set_master_volume(value: float) -> void:
	if value == null:
		value = 1.0
	AudioServer.set_bus_volume_db(master_bus_idx, linear_to_db(value))
	AudioServer.set_bus_mute(master_bus_idx, value <= 0.0)


func set_music_volume(value: float) -> void:
	if value == null:
		value = 0.8
	AudioServer.set_bus_volume_db(music_bus_idx, linear_to_db(value))
	AudioServer.set_bus_mute(music_bus_idx, value <= 0.0)


func set_sfx_volume(value: float) -> void:
	if value == null:
		value = 1.0
	AudioServer.set_bus_volume_db(sfx_bus_idx, linear_to_db(value))
	AudioServer.set_bus_mute(sfx_bus_idx, value <= 0.0)
