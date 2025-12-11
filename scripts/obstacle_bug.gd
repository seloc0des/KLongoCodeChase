extends Area2D
class_name ObstacleBug

@export var obstacle_type: String = "bug"
@export var damage_on_contact: bool = true
@export var highlight_color: Color = Color(1, 0.5, 0, 1)
@export var float_amplitude: float = 20.0
@export var float_speed: float = 3.0

@onready var sprite: ColorRect = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var warning_indicator: ColorRect = $WarningIndicator

var initial_y: float
var time_offset: float


func _ready() -> void:
	initial_y = position.y
	time_offset = randf() * TAU
	
	GameManager.powerup_activated.connect(_on_powerup_activated)
	GameManager.powerup_deactivated.connect(_on_powerup_deactivated)
	
	collision_layer = 4
	collision_mask = 0
	
	if warning_indicator:
		warning_indicator.visible = false
	
	if GameManager.rubber_duck_active:
		_show_warning()


func _process(_delta: float) -> void:
	# Floating animation
	position.y = initial_y + sin(Time.get_ticks_msec() * 0.001 * float_speed + time_offset) * float_amplitude


func _on_body_entered(body: Node2D) -> void:
	if body is Player and damage_on_contact:
		body.hit_obstacle()


func _on_powerup_activated(powerup_type: String) -> void:
	if powerup_type == "rubber_duck":
		_show_warning()


func _on_powerup_deactivated(powerup_type: String) -> void:
	if powerup_type == "rubber_duck":
		_hide_warning()


func _show_warning() -> void:
	if warning_indicator:
		warning_indicator.visible = true
	if sprite:
		sprite.modulate = highlight_color


func _hide_warning() -> void:
	if warning_indicator:
		warning_indicator.visible = false
	if sprite:
		sprite.modulate = Color.WHITE
