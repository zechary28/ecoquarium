# species_status_bar

extends Control

var fish_species: FishSpecies

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = fish_species.display_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_species_bar_o2(currentO2: int) -> void:
	var healthy := currentO2 >= fish_species.o2_min
	$ProgressBarO2.value = fish_species.margin_fraction(currentO2, fish_species.o2_min) * 100.0
	$ProgressBarO2.add_theme_color_override("fill_color", Color.GREEN if healthy else Color.RED)

func _update_species_bar_food(currentFood: int) -> void:
	var healthy := currentFood >= fish_species.food_min
	$ProgressBarFood.value = fish_species.margin_fraction(currentFood, fish_species.food_min) * 100.0
	$ProgressBarFood.add_theme_color_override("fill_color", Color.GREEN if healthy else Color.RED)
