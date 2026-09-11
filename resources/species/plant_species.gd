extends Resource
class_name PlantSpecies
 
@export var display_name: String = "Plant"
@export var cost: float = 5.0
@export var co2_consumption: float = 1.0   # fixed, before light multiplier
@export var o2_production: float = 1.0     # fixed, before light multiplier
@export var sprite: Texture2D
