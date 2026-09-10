extends Node2D

@export var fish_scene: PackedScene
@export var plant_scene: PackedScene
@export var food_effect_scene: PackedScene
@export var sprite_frames: SpriteFrames
@export var available_species: Array[FishSpecies] = []

var pending_fish: FishSpecies = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# TODO CONNECT SELECT FISH
# called by the sidebar's fish_purchase_requested signal
func _on_fish_purchase_requested(species: FishSpecies) -> void:
	pending_fish = species  # don't spend yet — wait for placement

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		#_drop_food(event.position)
		#print("dropping food")
		_place_plant(event.position)
	elif (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT):
		_place_fish(event.position)

func _make_placeholder_fishspecies() -> FishSpecies:
	var species := FishSpecies.new()
	species.o2_consumption = 2
	species.food_consumption = 1
	species.co2_production = 2
	species.aesthetic_value = 5
	species.sprite_frames = sprite_frames
	return species

func _make_placeholder_plantspecies() -> PlantSpecies:
	var species := PlantSpecies.new()
	species.co2_consumption = 2
	species.o2_production = 2
	return species

var pending_species = preload("res://resources/species/angelfish.tres")

func _place_fish(pos: Vector2) -> void:
	#if not Aquarium._updateMoney(pending_fish.cost):
		#return
	var fish := fish_scene.instantiate()
	# TODO CHANGE TO SELECTED FISH
	var chosen_species : FishSpecies = available_species.pick_random()
	fish.species = chosen_species
	$EntityContainer.add_child(fish)
	fish.global_position = pos
	fish.reset_target()
	# pending_fish = null

func _place_plant(pos: Vector2) -> void:
	#if not Aquarium._updateMoney(pending_fish.cost):
		#return
	var plant := plant_scene.instantiate()
	plant.species = _make_placeholder_plantspecies()
	#fish.species = pending_fish
	plant.position = pos
	$EntityContainer.add_child(plant)
	#pending_fish = null

func _drop_food(pos: Vector2) -> void:
	Aquarium._updateFood(5.0)
	var effect := food_effect_scene.instantiate()
	effect.position = pos
	$EffectContainer.add_child(effect)
