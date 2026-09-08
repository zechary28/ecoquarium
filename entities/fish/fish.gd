extends Node2D

@export var species: FishSpecies
var health: float = 100.0

func get_contribution(current_o2: float, current_food: float) -> Dictionary:
	var o2_deficit = max(0.0, 40.0 - current_o2)  # stress below 40%
	health -= o2_deficit * species.o2_sensitivity * 0.01
	health = clampf(health, 0.0, 100.0)
	return {
		"o2_consumed": species.o2_consumption * (health / 100.0),
		"co2_produced": species.co2_production,
		"food_consumed": species.food_consumption,
		"beauty": species.aesthetic_value * (health / 100.0) if health > 20.0 else 0.0
	}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
