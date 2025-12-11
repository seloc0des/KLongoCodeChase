extends Node2D
class_name LevelManager

signal segment_spawned(segment: Node2D)

@export var segment_width: float = 720.0
@export var spawn_ahead_distance: float = 1440.0
@export var despawn_behind_distance: float = 720.0

# Segment scene paths by difficulty
var easy_segments: Array[PackedScene] = []
var medium_segments: Array[PackedScene] = []
var hard_segments: Array[PackedScene] = []

var active_segments: Array[Node2D] = []
var next_segment_x: float = 0.0
var camera_ref: Camera2D


func _ready() -> void:
	_load_segment_scenes()


func _load_segment_scenes() -> void:
	# Load segment scenes
	easy_segments = [
		preload("res://scenes/level/LevelSegment_Easy_01.tscn"),
		preload("res://scenes/level/LevelSegment_Easy_02.tscn"),
	]
	medium_segments = [
		preload("res://scenes/level/LevelSegment_Med_01.tscn"),
		preload("res://scenes/level/LevelSegment_Med_02.tscn"),
	]
	hard_segments = [
		preload("res://scenes/level/LevelSegment_Hard_01.tscn"),
		preload("res://scenes/level/LevelSegment_Hard_02.tscn"),
	]


func initialize(camera: Camera2D) -> void:
	camera_ref = camera
	next_segment_x = 0.0
	
	# Clear any existing segments
	for segment in active_segments:
		segment.queue_free()
	active_segments.clear()
	
	# Spawn initial segments
	for i in range(3):
		_spawn_next_segment()


func _process(_delta: float) -> void:
	if not camera_ref or GameManager.current_state != GameManager.GameState.PLAYING:
		return
	
	var camera_x = camera_ref.global_position.x
	
	# Spawn new segments ahead of camera
	while next_segment_x < camera_x + spawn_ahead_distance:
		_spawn_next_segment()
	
	# Despawn segments behind camera
	_cleanup_old_segments(camera_x)


func _spawn_next_segment() -> void:
	var segment_scene = _select_segment_for_difficulty()
	var segment = segment_scene.instantiate()
	
	segment.position.x = next_segment_x
	add_child(segment)
	active_segments.append(segment)
	
	next_segment_x += segment_width
	segment_spawned.emit(segment)


func _select_segment_for_difficulty() -> PackedScene:
	var tier = GameManager.difficulty_tier
	var roll = randf()
	
	match tier:
		0:  # Easy tier - mostly easy segments
			if roll < 0.9:
				return easy_segments.pick_random()
			else:
				return medium_segments.pick_random()
		1:  # Medium tier - mix of easy and medium
			if roll < 0.3:
				return easy_segments.pick_random()
			elif roll < 0.85:
				return medium_segments.pick_random()
			else:
				return hard_segments.pick_random()
		2:  # Hard tier - mix of medium and hard
			if roll < 0.1:
				return easy_segments.pick_random()
			elif roll < 0.4:
				return medium_segments.pick_random()
			else:
				return hard_segments.pick_random()
	
	# Fallback for any tier >= 3
	return easy_segments.pick_random()


func _cleanup_old_segments(camera_x: float) -> void:
	var segments_to_remove: Array[Node2D] = []
	
	for segment in active_segments:
		if segment.position.x + segment_width < camera_x - despawn_behind_distance:
			segments_to_remove.append(segment)
	
	for segment in segments_to_remove:
		active_segments.erase(segment)
		segment.queue_free()


func reset() -> void:
	for segment in active_segments:
		segment.queue_free()
	active_segments.clear()
	next_segment_x = 0.0
