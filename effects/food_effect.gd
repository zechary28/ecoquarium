extends Node2D

@export_range(1, 40, 1) var particle_count: int = 14
@export var minimum_burst_distance: float = 24.0
@export var maximum_burst_distance: float = 64.0
@export var burst_duration: float = 0.28
@export var drift_duration: float = 1.25
@export var downward_drift: float = 34.0

@onready var particle_template: Sprite2D = $Sprite2D

func _ready() -> void:
	particle_template.hide()
	_spawn_food_particles()


func _spawn_food_particles() -> void:
	for index in particle_count:
		var particle := Sprite2D.new()
		particle.texture = particle_template.texture
		particle.centered = particle_template.centered
		particle.modulate = particle_template.modulate

		var starting_scale := randf_range(0.28, 0.55)
		particle.scale = Vector2.ONE * starting_scale
		particle.rotation = randf_range(-PI, PI)
		add_child(particle)

		var angle := randf_range(0.0, TAU)
		var direction := Vector2.RIGHT.rotated(angle)
		var burst_distance := randf_range(
			minimum_burst_distance,
			maximum_burst_distance
		)
		var burst_target := direction * burst_distance
		var drift_target := burst_target + Vector2(
			randf_range(-12.0, 12.0),
			downward_drift
		)

		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property(
			particle,
			"position",
			burst_target,
			burst_duration
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(
			particle,
			"rotation",
			particle.rotation + randf_range(-1.5, 1.5),
			burst_duration
		)

		tween.chain().set_parallel(true)
		tween.tween_property(
			particle,
			"position",
			drift_target,
			drift_duration
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween.tween_property(
			particle,
			"modulate:a",
			0.0,
			drift_duration
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.tween_property(
			particle,
			"scale",
			Vector2.ONE * starting_scale * 0.65,
			drift_duration
		)

		tween.finished.connect(particle.queue_free)


func _on_timer_timeout() -> void:
	queue_free()
