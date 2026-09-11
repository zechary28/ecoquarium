# fish_species.gd

extends Resource
class_name FishSpecies

@export var display_name: String
@export var cost: int
@export var o2_consumption: float
@export var food_consumption: float
@export var co2_production: float
@export var aesthetic_value: int
@export var o2_min: float = 40.0
@export var food_min: float = 20.0
@export_range(0.0, 1.0, 0.001) var death_chance_per_tick: float = 0.01
@export var sprite: Texture2D
@export var sprite_frames: SpriteFrames

func _margin_fraction(current: float, threshold: float, max_value: float = 100.0) -> float:
	if current >= threshold:
		var healthy_range := max_value - threshold
		return (current - threshold) / healthy_range if healthy_range > 0.0 else 1.0
	else:
		return (threshold - current) / threshold if threshold > 0.0 else 0.0

func margin_fraction_o2(current_o2: float, max_value: float = 100.0) -> float:
	return _margin_fraction(current_o2, o2_min, max_value)

func margin_fraction_food(current_food: float, max_value: float = 100.0) -> float:
	return _margin_fraction(current_food, food_min, max_value)
