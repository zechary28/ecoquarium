#select_fish_button.gd

extends Control

class_name SelectFishButton

var species: FishSpecies = null

signal fish_selected(species: FishSpecies)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if species:
		$VBox/LabelName.text = species.display_name if species else "???"
		$VBox/LabelPrice.text = str(species.cost) if species else "???"
		$VBox/LabelConsumption.text = "%dO2 + %dFood -> %dCO2" % [species.o2_consumption, species.food_consumption, species.co2_production]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		#fish_selected.emit(species)
		emit_signal("fish_selected", species)
		print("%s species selected" % [species.display_name])
