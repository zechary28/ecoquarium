extends TextureButton

@export var lift_height: float = 6.0
@export var gold_outline_color: Color = Color("#EED840")

var original_pos_y: float
var interaction_tween: Tween
var idle_timer: Timer
var is_hovered: bool = false
var shader_mat: ShaderMaterial
var is_locked: bool = false

func lock_interaction() -> void:
	is_locked = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if idle_timer:
		idle_timer.stop()
	if interaction_tween and interaction_tween.is_valid():
		interaction_tween.kill()
	

func _ready() -> void:
	original_pos_y = position.y
	pivot_offset = size / 2.0

	if material is ShaderMaterial:
		shader_mat = material.duplicate()
		material = shader_mat
		shader_mat.set_shader_parameter("outline_color", gold_outline_color)
		shader_mat.set_shader_parameter("outline_intensity", 0.0)

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	_start_idle_glimmer_timer()

func _start_idle_glimmer_timer() -> void:
	idle_timer = Timer.new()
	idle_timer.wait_time = randf_range(4.0, 6.0)
	idle_timer.one_shot = true
	idle_timer.timeout.connect(_on_idle_pulse)
	add_child(idle_timer)
	idle_timer.start()

func _on_mouse_entered() -> void:
	is_hovered = true
	if idle_timer:
		idle_timer.stop()
	if interaction_tween and interaction_tween.is_valid():
		interaction_tween.kill()

	interaction_tween = create_tween().set_parallel(true)
	interaction_tween.tween_property(self, "position:y", original_pos_y - lift_height, 0.18)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	interaction_tween.tween_property(self, "modulate", Color(1.1, 1.1, 1.05, 1.0), 0.18)
	if shader_mat:
		interaction_tween.tween_property(shader_mat, "shader_parameter/outline_intensity", 1.0, 0.18)
	interaction_tween.tween_property(self, "scale", Vector2(1.06, 1.06), 0.18)\
	.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_mouse_exited() -> void:
	is_hovered = false
	if interaction_tween and interaction_tween.is_valid():
		interaction_tween.kill()

	interaction_tween = create_tween().set_parallel(true)
	interaction_tween.tween_property(self, "position:y", original_pos_y, 0.2)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	interaction_tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	if shader_mat:
		interaction_tween.tween_property(shader_mat, "shader_parameter/outline_intensity", 0.0, 0.2)

	if idle_timer:
		idle_timer.start(randf_range(4.0, 6.0))
	interaction_tween.tween_property(self, "scale", Vector2.ONE, 0.2)\
	.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _on_idle_pulse() -> void:
	if is_hovered or not shader_mat:
		return

	var pulse_tween: Tween = create_tween()

	# 1. Ramp up: bloom outline, brighten, and gently swell scale
	pulse_tween.set_parallel(true)
	pulse_tween.tween_property(shader_mat, "shader_parameter/outline_intensity", 1.0, 0.8)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	pulse_tween.tween_property(self, "modulate", Color(1.25, 1.22, 1.1, 1.0), 0.8)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	pulse_tween.tween_property(self, "scale", Vector2(1.04, 1.04), 0.8)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# 2. Hold at peak glow and scale
	pulse_tween.chain().tween_interval(1.0)

	# 3. Fade down: reduce outline, normalize color, and settle back to normal scale
	pulse_tween.chain().set_parallel(true)
	pulse_tween.tween_property(shader_mat, "shader_parameter/outline_intensity", 0.0, 1.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	pulse_tween.tween_property(self, "modulate", Color.WHITE, 1.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	pulse_tween.tween_property(self, "scale", Vector2.ONE, 1.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	await pulse_tween.finished

	if not is_hovered and idle_timer:
		idle_timer.start(randf_range(4.0, 6.0))
