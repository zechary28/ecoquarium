extends Control

@export_file("*.tscn") var main_scene_path: String = "res://main.tscn"
@onready var magazine_button: TextureButton = $Journal

func _ready() -> void:
	magazine_button.pressed.connect(_on_magazine_pressed)

func _on_magazine_pressed() -> void:
	magazine_button.lock_interaction()
	magazine_button.disabled = true
	magazine_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if magazine_button.has_node("Timer"):
		magazine_button.get_node("Timer").stop
	magazine_button.z_index = 10 
	
	var viewport_size: Vector2 = get_viewport_rect().size
	var viewport_center: Vector2 = viewport_size / 2.0
	
	# Phase 1: Inspect & Read (slow, elegant zoom to center)
	var inspect_tween: Tween = create_tween().set_parallel(true)
	inspect_tween.tween_property(magazine_button, "global_position", viewport_center - (magazine_button.size * 1.25), 1.1)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	inspect_tween.tween_property(magazine_button, "scale", Vector2(2.5, 2.5), 1.1)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	inspect_tween.tween_property(magazine_button, "rotation", 0.0, 1.0)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	await inspect_tween.finished
	
	# Brief moment to let the player register the centered journal
	await get_tree().create_timer(0.4).timeout
	
	# Phase 2: Snap toward the tank (accelerating dive upward into the glass)
	# Target: upper center of the viewport where the aquarium sits
	var tank_target_pos: Vector2 = Vector2(viewport_center.x - (magazine_button.size.x * 2.5), -viewport_size.y * 0.2)
	
	var plunge_tween: Tween = create_tween().set_parallel(true)
	# Plunges upward toward the tank
	plunge_tween.tween_property(magazine_button, "global_position", tank_target_pos, 0.45)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	# Massive scale up so it flies "past" the camera/into the glass
	plunge_tween.tween_property(magazine_button, "scale", Vector2(5.0, 5.0), 0.45)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	# Slight tilt during the plunge for dynamic weight
	plunge_tween.tween_property(magazine_button, "rotation", deg_to_rad(-6.0), 0.45)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	# Kick off the dither right as the snap gathers momentum
	SceneTransition.change_scene(main_scene_path, 0.45)
