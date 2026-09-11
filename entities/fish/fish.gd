extends Node2D

class_name Fish

signal died(fish: Fish)

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
var facing_sign: int = 1
var is_dying: bool = false

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
	if is_dying or species == null:
		return {}

	var unhealthy: bool = current_o2 < species.o2_min or current_food < species.food_min
	if unhealthy and randf() < species.death_chance_per_tick:
		_die()
		return {}

	return {
		"o2_consumed": species.o2_consumption,
		"co2_produced": species.co2_production,
		"food_consumed": species.food_consumption,
		"beauty": species.aesthetic_value
	}

func _die() -> void:
	if is_dying:
		return
	is_dying = true
	set_process(false)
	remove_from_group("fish")
	died.emit(self)

	if sprite.sprite_frames and sprite.sprite_frames.has_animation("dead"):
		sprite.play("dead")

	sprite.flip_h = (facing_sign == -1)

	var surface_y: float = ceiling_offset
	var distance_to_top: float = absf(global_position.y - surface_y)

	# --- RISE SPEED CONFIG ---
	# Lower divisor = slower rise (approx 25-30 pixels per second)
	# Min duration raised to 3.0s so even fish near the surface linger
	var float_duration: float = clampf(distance_to_top / 28.0, 3.0, 6.0)

	# Parallel master tween
	var tween: Tween = create_tween().set_parallel(true)

	# 1. Level tilt & subtle cold discoloration
	tween.tween_property(self, "rotation", 0.0, 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "modulate", Color(0.65, 0.72, 0.8, 1.0), 1.0)

	# 2. Slow ascent to the surface
	tween.tween_property(self, "global_position:y", surface_y, float_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# --- GENTLE SWAY CONFIG ---
	var sway: Tween = create_tween().set_parallel(false)
	var cycles: int = 4
	var step_t: float = float_duration / float(cycles)
	var sway_offset: float = 2.5 # Reduced from 6.0 down to 2.5 pixels for a subtle drift

	for i in range(cycles):
		var side: float = 1.0 if i % 2 == 0 else -1.0
		# Gentle translation back and forth
		sway.tween_property(self, "global_position:x", global_position.x + (sway_offset * side), step_t)\
			.set_trans(Tween.TRANS_SINE)

	# 3. Fade out after reaching the surface and resting a moment
	var cleanup_tween: Tween = create_tween()
	cleanup_tween.tween_interval(float_duration + 0.8) # Wait for float + brief surface rest
	cleanup_tween.tween_property(self, "modulate:a", 0.0, 1.2) # Slower, gentler fade
	cleanup_tween.tween_callback(queue_free)

func _process(delta: float) -> void:
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
