extends Control

@onready var play_button: TextureButton = $TextureButton # Adjust to your button's name

func _on_texture_button_pressed() -> void:
	play_button.disabled = true
	SceneTransition.change_scene("res://scenes/intro_scene.tscn", 1.8)
