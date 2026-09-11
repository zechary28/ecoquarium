extends Control

@onready var play_button: TextureButton = $TextureButton # Adjust to your button's name
@onready var fade_overlay: ColorRect = $FadeOverlay

func _ready() -> void:
	fade_overlay.modulate.a = 0.0

func _on_texture_button_pressed() -> void:
	AudioManager.play_ui_click()
	# Disable the button and block input during transition
	play_button.disabled = true
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Create a tween to fade in the black overlay over 0.5 seconds
	var tween: Tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 1.0, 1.5)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

	# Wait for the fade-out to finish before loading the intro scene
	await tween.finished

	get_tree().change_scene_to_file("res://intro_scene.tscn")
