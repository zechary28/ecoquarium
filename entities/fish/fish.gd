extends Node2D

class_name Fish

@export var species: FishSpecies

@export_group("Movement")
@export var speed: float = 60.0
@export var turn_speed: float = 4.0
@export var slow_down_radius: float = 120.0


@export_group("Tank Offsets")
@export var ceiling_offset: float = 100.0  # Pixels away from the surface
@export var ground_offset: float = 120.0   # Pixels away from the tank floor
@export var side_margin: float = 75.0      # Pixels away from left/right glass

var target_position: Vector2 = Vector2.ZERO
var wait_timer: float = 0.0
var health: float = 100.0
var facing_sign: int = 1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("fish")
	if species and species.sprite_frames:
		sprite.sprite_frames = species.sprite_frames
	call_deferred("reset_target")

func reset_target() -> void:
	_pick_new_target()
	var to_target: Vector2 = target_position - global_position
	facing_sign = -1 if to_target.x < 0 else 1
	_update_animation(true)

func get_contribution(current_o2: float, current_food: float) -> Dictionary:
	if species == null:
		return {}
	return {
		"o2_consumed": species.o2_consumption,
		"co2_produced": species.co2_production,
		"food_consumed": species.food_consumption,
		"beauty": species.aesthetic_value
	}

func apply_damage(amount: float) -> void:
	health -= amount
	if health <= 0.0:
		_die()

func _die() -> void:
	queue_free()

func _process(delta: float) -> void:
	# Keep health check above returns so it runs continuously
	if health <= 0.0:
		_die()
		return

	# Idle / waiting logic
	if wait_timer > 0.0:
		wait_timer -= delta
		# Level the fish horizontally while resting
		rotation = lerp_angle(rotation, 0.0, turn_speed * delta)
		_update_animation(false)
		if wait_timer <= 0.0:
			_pick_new_target()
		return

	_move_towards_target(delta)

func _move_towards_target(delta: float) -> void:
	var to_target: Vector2 = target_position - global_position
	var distance: float = to_target.length()

	# Destination reached: enter idle state
	if distance <= 2.0:
		wait_timer = randf_range(0.8, 2.5)
		return

	# Speed easing
	var current_speed: float = speed
	if distance < slow_down_radius:
		var t: float = distance / slow_down_radius
		current_speed = speed * ease(t, 0.5)
		current_speed = maxf(current_speed, 12.0)

	var step: float = current_speed * delta
	global_position = global_position.move_toward(target_position, step)

	# Clamping inside tank bounds
	var vp: Vector2 = get_viewport_rect().size
	global_position.x = clampf(global_position.x, side_margin, vp.x - side_margin)
	global_position.y = clampf(global_position.y, ceiling_offset, vp.y - ground_offset)

	var move_dir: Vector2 = to_target.normalized()
	if move_dir.x < -0.05:
		facing_sign = -1
	elif move_dir.x > 0.05:
		facing_sign = 1
	# 1. Update animation smoothly:
	# Only swap left/right when the target is clearly on the other side
	_update_animation(true)

	# 2. Smoothly rotate towards heading
	var target_angle: float = 0.0
	if facing_sign == 1:
		target_angle = atan2(move_dir.y, move_dir.x)
	else:
		target_angle = atan2(-move_dir.y, -move_dir.x)

	# Gentle clamp on pitch tilt
	target_angle = clampf(target_angle, deg_to_rad(-70.0), deg_to_rad(70.0))
	rotation = lerp_angle(rotation, target_angle, turn_speed * delta)

func _pick_new_target() -> void:
	var vp: Vector2 = get_viewport_rect().size
	var min_x: float = side_margin
	var max_x: float = vp.x - side_margin
	var min_y: float = ceiling_offset
	var max_y: float = vp.y - ground_offset
	target_position = Vector2(randf_range(min_x, max_x), randf_range(min_y, max_y))
func _update_animation(is_swimming: bool) -> void:
	if sprite == null or sprite.sprite_frames == null:
		return

	var target_anim: String = ""
	if is_swimming:
		target_anim = "swim_left" if facing_sign == -1 else "swim_right"
	else:
		target_anim = "default_left" if facing_sign == -1 else "default_right"

	if sprite.sprite_frames.has_animation(target_anim):
		if sprite.animation != target_anim or not sprite.is_playing():
			sprite.play(target_anim)
