extends Control

@onready var play_button: TextureButton = $TextureButton # Adjust to your button's name

func _on_texture_button_pressed() -> void:
	AudioManager.play_ui_click()
	play_button.disabled = true
	SceneTransition.change_scene("res://scenes/intro_scene.tscn", 1.8)
