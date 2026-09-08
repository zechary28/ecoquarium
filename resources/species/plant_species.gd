extends Resource
class_name PlantSpecies

@export var display_name: String = "Plant"
@export var cost: float = 5.0
@export var co2_consumption: float = 1.0
@export var o2_production: float = 1.0
@export var light_requirement: int = 1  # 0 = off, 1 = low, 2 = high
@export var sprite: Texture2D
