# fish_species.gd

extends Resource
class_name FishSpecies

@export var display_name: String
@export var cost: int
@export var o2_consumption: float
@export var food_consumption: float
@export var co2_production: float
@export var aesthetic_value: int
@export var o2_min: int = 40
@export var food_min: int = 20
@export var death_chance_per_tick: float = 0.05   # 5%, tune per species
@export var sprite: Texture2D
@export var sprite_frames: SpriteFrames

# 0 at the threshold boundary, 1 at the extreme (either O2=0 or O2=max)
func margin_fraction_o2(currentO2: int, max_value: int = 100) -> float:
	if currentO2 >= o2_min:
		return (currentO2 - o2_min) / (max_value - o2_min)
	else:
		return (o2_min - currentO2) / o2_min

# 0 at the threshold boundary, 1 at the extreme (either O2=0 or O2=max)
func margin_fraction_food(currentFood: int, max_value: int = 100) -> float:
	if currentFood >= food_min:
		return (currentFood - food_min) / (max_value - food_min)
	else:
		return (food_min - currentFood) / food_min
