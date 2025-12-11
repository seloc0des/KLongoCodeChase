extends Node2D
class_name LevelSegment

@export var segment_difficulty: int = 0  # 0=easy, 1=medium, 2=hard
@export var segment_width: float = 720.0

# Child nodes are set up in the scene
# This script provides common functionality


func _ready() -> void:
	# Any initialization for the segment
	pass


func get_width() -> float:
	return segment_width
