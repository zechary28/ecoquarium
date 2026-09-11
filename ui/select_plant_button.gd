extends HBoxContainer

class_name SelectPlantButton

signal plant_selected(species: PlantSpecies)
signal plant_selection_changed(species: PlantSpecies, is_selected: bool)

var species: PlantSpecies
var is_hovered := false


func _ready() -> void:
	if species == null:
		return

	$CostRow/LabelPrice.text = "%d" % int(species.cost)
	$IconButton.tooltip_text = "%s\nO2 production: %.2f/s\nCO2 use: %.2f/s" % [
		species.display_name,
		species.o2_production,
		species.co2_consumption,
	]
	$IconButton/Icon.texture = _get_plant_icon()
	$IconButton.pivot_offset = $IconButton.size * 0.5
	_refresh_visual_state()


func _get_plant_icon() -> Texture2D:
	if species.sprite == null:
		return null

	var icon := AtlasTexture.new()
	icon.atlas = species.sprite
	icon.region = Rect2(64.0, 0.0, 32.0, 64.0)
	return icon


func _on_icon_button_toggled(is_selected: bool) -> void:
	if species:
		plant_selection_changed.emit(species, is_selected)
	_refresh_visual_state()


func _on_icon_button_mouse_entered() -> void:
	is_hovered = true
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
