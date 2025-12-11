extends Area2D
class_name Obstacle

@export var obstacle_type: String = "generic"
@export var damage_on_contact: bool = true
@export var highlight_color: Color = Color.RED

@onready var sprite: CanvasItem = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var warning_indicator: ColorRect = $WarningIndicator

var is_highlighted: bool = false


func _ready() -> void:
	# Connect to powerup signals for rubber duck highlighting
	GameManager.powerup_activated.connect(_on_powerup_activated)
	GameManager.powerup_deactivated.connect(_on_powerup_deactivated)
	
	# Set up collision
	collision_layer = 4  # Obstacles layer
	collision_mask = 0
	
	# Hide warning indicator by default
	if warning_indicator:
		warning_indicator.visible = false
	
	# Check if rubber duck is already active
	if GameManager.rubber_duck_active:
		_show_warning()


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
	is_highlighted = true
	if warning_indicator:
		warning_indicator.visible = true
	# Also add outline effect to sprite
	if sprite:
		sprite.modulate = highlight_color


func _hide_warning() -> void:
	is_highlighted = false
	if warning_indicator:
		warning_indicator.visible = false
	if sprite:
		sprite.modulate = Color.WHITE


func get_colorblind_safe_color() -> Color:
	# Return patterns/shapes instead of relying solely on color
	if GameManager.settings.get("colorblind_mode", false):
		return Color.WHITE  # Use white with distinct patterns
	return highlight_color
