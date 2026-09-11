# species_status_bar

extends VBoxContainer

var species: FishSpecies = null
var fish_count: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "%s  x%d" % [species.display_name, fish_count]
	Aquarium.stats_changed.connect(_on_stats_changed)
	_on_stats_changed()

func _update_species_bar_o2(currentO2: float) -> void:
	var healthy := currentO2 >= species.o2_min
	$Meters/ProgressBarO2.value = species.margin_fraction_o2(currentO2) * 100.0
	$Meters/ProgressBarO2.tint_progress = Color(0.25, 0.9, 0.95) if healthy else Color(0.95, 0.28, 0.2)
	$Meters/ProgressBarO2.tooltip_text = "O2 %d / minimum %d" % [int(currentO2), species.o2_min]

func _update_species_bar_food(currentFood: float) -> void:
	var healthy := currentFood >= species.food_min
	$Meters/ProgressBarFood.value = species.margin_fraction_food(currentFood) * 100.0
	$Meters/ProgressBarFood.tint_progress = Color(0.9, 0.7, 0.25) if healthy else Color(0.95, 0.28, 0.2)
	$Meters/ProgressBarFood.tooltip_text = "Food %d / minimum %d" % [int(currentFood), species.food_min]

func _on_stats_changed() -> void:
	_update_species_bar_o2(Aquarium.O2Level)
	_update_species_bar_food(Aquarium.FoodLevel)
