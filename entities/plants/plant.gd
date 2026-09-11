extends Node2D

class_name Plant

const LIGHT_MULTIPLIERS := [0.0, 0.45, 0.75, 1.0, 1.15, 1.30]
const CO2_FOR_FULL_OUTPUT: float = 25.0
 
@export var species: PlantSpecies

@onready var sprite: Sprite2D = $Sprite2D
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("plants")
	if species and species.sprite:
		$Sprite2D.texture = species.sprite
		
	sprite.hframes = 4
	sprite.vframes = 1
	sprite.frame = randi_range(0, 3)

func get_contribution(current_light: int, current_co2: float) -> Dictionary:
	if species == null:
		return {}

	var light_factor: float = LIGHT_MULTIPLIERS[clampi(current_light, 0, 5)]
	var co2_factor: float = clampf(current_co2 / CO2_FOR_FULL_OUTPUT, 0.0, 1.0)
	return {
		"o2_produced": species.o2_production * light_factor * co2_factor,
		"co2_consumed": species.co2_consumption * light_factor * co2_factor
	}
 
