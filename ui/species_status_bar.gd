# species_status_bar

extends Control

var species: FishSpecies = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = species.display_name
	Aquarium.stats_changed.connect(_on_stats_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_species_bar_o2(currentO2: int) -> void:
	var healthy := currentO2 >= species.o2_min
	$ProgressBarO2.value = species.margin_fraction_o2(currentO2, species.o2_min) * 100.0
	$ProgressBarO2.add_theme_color_override("fill_color", Color.GREEN if healthy else Color.RED)

func _update_species_bar_food(currentFood: int) -> void:
	var healthy := currentFood >= species.food_min
	$ProgressBarFood.value = species.margin_fraction_food(currentFood, species.food_min) * 100.0
	$ProgressBarFood.add_theme_color_override("fill_color", Color.GREEN if healthy else Color.RED)

func _on_stats_changed() -> void:
	_update_species_bar_o2(Aquarium.O2Level)
	_update_species_bar_food(Aquarium.FoodLevel)
