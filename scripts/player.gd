extends CharacterBody2D
class_name Player

signal died
signal landed

@export var jump_velocity: float = -600.0
@export var gravity: float = 1800.0
@export var max_fall_speed: float = 1200.0
@export var jump_hold_gravity_multiplier: float = 0.5
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.1

@onready var sprite: Polygon2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var trail_particles: GPUParticles2D = $TrailParticles

var is_jumping: bool = false
var is_holding_jump: bool = false
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var was_on_floor: bool = false
var is_dead: bool = false

# Visual feedback
var squash_stretch_tween: Tween


func _ready() -> void:
	# Connect to game signals
	GameManager.powerup_activated.connect(_on_powerup_activated)
	GameManager.powerup_deactivated.connect(_on_powerup_deactivated)
	
	# Initialize trail
	if trail_particles:
		trail_particles.emitting = false


func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	# Apply gravity
	var current_gravity = gravity
	if is_jumping and is_holding_jump and velocity.y < 0:
		current_gravity *= jump_hold_gravity_multiplier
	
	velocity.y += current_gravity * delta
	velocity.y = min(velocity.y, max_fall_speed)
	
	# Handle coyote time
	if is_on_floor():
		coyote_timer = coyote_time
		if not was_on_floor:
			_on_land()
	else:
		coyote_timer -= delta
	
	was_on_floor = is_on_floor()
	
	# Handle jump buffer
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
		if can_jump():
			_perform_jump()
	
	# Move the player
	move_and_slide()
	
	# Check for collision with obstacles (handled by Area2D signals)


func _input(event: InputEvent) -> void:
	if is_dead:
		return
	
	if event.is_action_pressed("jump"):
		is_holding_jump = true
		if can_jump():
			_perform_jump()
		else:
			jump_buffer_timer = jump_buffer_time
	
	if event.is_action_released("jump"):
		is_holding_jump = false
		# Cut jump short if released early
		if velocity.y < 0:
			velocity.y *= 0.5


func can_jump() -> bool:
	return is_on_floor() or coyote_timer > 0


func _perform_jump() -> void:
	velocity.y = jump_velocity
	is_jumping = true
	coyote_timer = 0.0
	jump_buffer_timer = 0.0
	
	# Visual feedback - squash then stretch
	_apply_squash_stretch(Vector2(1.3, 0.7), Vector2(0.8, 1.2), 0.1)
	
	# Audio
	AudioManager.play_sfx("jump")


func _on_land() -> void:
	is_jumping = false
	landed.emit()
	
	# Visual feedback - squash on land
	_apply_squash_stretch(Vector2(1.3, 0.7), Vector2(1.0, 1.0), 0.15)
	
	# Audio
	AudioManager.play_sfx("land")


func _apply_squash_stretch(squash: Vector2, stretch: Vector2, duration: float) -> void:
	if squash_stretch_tween:
		squash_stretch_tween.kill()
	
	squash_stretch_tween = create_tween()
	squash_stretch_tween.tween_property(sprite, "scale", squash, duration * 0.3)
	squash_stretch_tween.tween_property(sprite, "scale", stretch, duration * 0.3)
	squash_stretch_tween.tween_property(sprite, "scale", Vector2.ONE, duration * 0.4)


func hit_obstacle() -> void:
	# Check for bug squash powerup
	if GameManager.use_bug_squash():
		# Play shield effect
		_play_shield_effect()
		return
	
	die()


func die() -> void:
	if is_dead:
		return
	
	is_dead = true
	velocity = Vector2.ZERO
	
	# Visual feedback
	_play_death_effect()
	
	# Audio
	AudioManager.play_sfx("death")
	
	# Emit signal
	died.emit()
	
	# Notify game manager
	GameManager.end_game()


func _play_death_effect() -> void:
	# Flash red and fade out
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.RED, 0.1)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)
	tween.tween_property(sprite, "modulate", Color.RED, 0.1)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.3)


func _play_shield_effect() -> void:
	# Flash blue to indicate shield used
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.CYAN, 0.1)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.2)


func _on_powerup_activated(powerup_type: String) -> void:
	match powerup_type:
		"coffee":
			# Slow-mo visual indicator
			sprite.modulate = Color(0.6, 0.4, 0.2)  # Coffee brown tint
		"bug_squash":
			# Shield indicator
			sprite.modulate = Color(0.5, 1.0, 0.5)  # Green tint
		"rubber_duck":
			# Insight indicator
			sprite.modulate = Color(1.0, 1.0, 0.5)  # Yellow tint
			if trail_particles:
				trail_particles.emitting = true


func _on_powerup_deactivated(powerup_type: String) -> void:
	sprite.modulate = Color.WHITE
	if powerup_type == "rubber_duck" and trail_particles:
		trail_particles.emitting = false


func reset() -> void:
	is_dead = false
	is_jumping = false
	velocity = Vector2.ZERO
	sprite.modulate = Color.WHITE
	sprite.modulate.a = 1.0
	sprite.scale = Vector2.ONE


func _on_hit_area_entered(area: Area2D) -> void:
	if area is Obstacle or area is ObstacleBug:
		hit_obstacle()
	elif area is Pickup:
		area.collect()
