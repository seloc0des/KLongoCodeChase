extends Area2D
class_name Pickup

enum PickupType { FOCUS_ORB, COFFEE, BUG_SQUASH, RUBBER_DUCK }

@export var pickup_type: PickupType = PickupType.FOCUS_ORB
@export var orb_value: int = 1
@export var bob_amplitude: float = 10.0
@export var bob_speed: float = 4.0

@onready var sprite: ColorRect = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape

var initial_y: float
var time_offset: float
var is_collected: bool = false


func _ready() -> void:
	initial_y = position.y
	time_offset = randf() * TAU
	
	collision_layer = 8  # Pickups layer
	collision_mask = 0
	
	body_entered.connect(_on_body_entered)


func _process(_delta: float) -> void:
	if is_collected:
		return
	
	# Bobbing animation
	position.y = initial_y + sin(Time.get_ticks_msec() * 0.001 * bob_speed + time_offset) * bob_amplitude


func _on_body_entered(body: Node2D) -> void:
	if is_collected:
		return
	
	if body is Player:
		collect()


func collect() -> void:
	is_collected = true
	
	match pickup_type:
		PickupType.FOCUS_ORB:
			GameManager.add_orbs(orb_value)
			AudioManager.play_sfx("collect_orb")
		PickupType.COFFEE:
			GameManager.activate_powerup("coffee")
			AudioManager.play_sfx("powerup")
		PickupType.BUG_SQUASH:
			GameManager.activate_powerup("bug_squash")
			AudioManager.play_sfx("powerup")
		PickupType.RUBBER_DUCK:
			GameManager.activate_powerup("rubber_duck")
			AudioManager.play_sfx("powerup")
	
	# Play collection animation then remove
	_play_collect_animation()


func _play_collect_animation() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.15)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.15)
	tween.chain().tween_callback(queue_free)
