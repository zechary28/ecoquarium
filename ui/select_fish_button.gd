#select_fish_button.gd

extends HBoxContainer

class_name SelectFishButton

var species: FishSpecies = null
var is_hovered := false

signal fish_selection_changed(species: FishSpecies, is_selected: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if species:
		$CostRow/LabelPrice.text = "%d" % species.cost
		$IconButton.tooltip_text = "%s\nBeauty: %d\nO2 use: %.2f/s\nFood use: %.2f/s\nCO2 output: %.2f/s" % [
			species.display_name,
			species.aesthetic_value,
			species.o2_consumption,
			species.food_consumption,
			species.co2_production,
		]
		$IconButton/Icon.texture = _get_species_icon()
		$IconButton.pivot_offset = $IconButton.size * 0.5
		_refresh_visual_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _get_species_icon() -> Texture2D:
	if species.sprite_frames:
		for animation_name in [&"default_right", &"swim_right", &"default_left"]:
			if species.sprite_frames.has_animation(animation_name):
				return species.sprite_frames.get_frame_texture(animation_name, 0)
	return species.sprite


func _on_icon_button_toggled(is_selected: bool) -> void:
	if species:
		fish_selection_changed.emit(species, is_selected)
	_refresh_visual_state()


func _on_icon_button_mouse_entered() -> void:
	is_hovered = true
	AudioManager.play_ui_hover()
	_refresh_visual_state()


func _on_icon_button_mouse_exited() -> void:
	is_hovered = false
	_refresh_visual_state()


func _on_icon_button_button_down() -> void:
	$IconButton.scale = Vector2.ONE * 0.93


func _on_icon_button_button_up() -> void:
	_refresh_visual_state()


func _refresh_visual_state() -> void:
	if not is_node_ready():
		return

	if $IconButton.button_pressed:
		$IconButton.scale = Vector2.ONE * 0.96
		$IconButton.self_modulate = Color(0.78, 0.72, 0.65)
	elif is_hovered:
		$IconButton.scale = Vector2.ONE
		$IconButton.self_modulate = Color(1.15, 1.08, 0.95)
	else:
		$IconButton.scale = Vector2.ONE
		$IconButton.self_modulate = Color.WHITE
