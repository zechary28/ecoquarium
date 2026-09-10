# fish_species.gd
extends Resource
class_name FishSpecies

@export var display_name: String
@export var cost: int
@export var o2_consumption: int
@export var food_consumption: int
@export var co2_production: int
@export var aesthetic_value: int
@export var o2_sensitivity: float  # how fast health drops when O2 is low
@export var sprite: Texture2D
@export var sprite_frames: SpriteFrames
