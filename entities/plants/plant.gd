extends Node2D
 
@export var species: PlantSpecies
 
@onready var sprite: Sprite2D = $Sprite2D
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("plants")
	if species and species.sprite:
		sprite.texture = species.sprite

func get_contribution(current_light: int, current_co2: float) -> Dictionary:
	if species == null:
		return {}
	var light_factor := float(current_light)
	return {
		"o2_produced": species.o2_production * light_factor,
		"co2_consumed": species.co2_consumption * light_factor
	}
 
