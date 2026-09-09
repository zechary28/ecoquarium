extends Node2D

class_name Fish
 
@export var species: FishSpecies
 
func _ready() -> void:
	add_to_group("fish")
	if species and species.sprite:
		$Sprite2D.texture = species.sprite

var health: float = 100.0

func get_contribution(current_o2: float, current_food: float) -> Dictionary:
	if species == null:
		return {}
	return {
		"o2_consumed": species.o2_consumption,
		"co2_produced": species.co2_production,
		"food_consumed": species.food_consumption,
		"beauty": species.aesthetic_value
	}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
