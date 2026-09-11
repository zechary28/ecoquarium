extends Node2D

@export var fish_scene: PackedScene
@export var plant_scene: PackedScene
@export var food_effect_scene: PackedScene
@export var sprite_frames: SpriteFrames

var selected_fish: FishSpecies = null
const CATALOG := preload("res://resources/species_catalog.tres")
const SELECT_FISH_BUTTON_SCENE := preload("res://ui/select_fish_button.tscn")
const PLANT_MIN_Y := 535.0
const PLANT_MAX_Y := 580.0
const PLANT_MIN_X := 40.0
const PLANT_MAX_X := 1100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load all available fish species
	for species in CATALOG.fish_species:
		var sfb = SELECT_FISH_BUTTON_SCENE.instantiate()
		sfb.species = species
		sfb.fish_selected.connect(_on_fish_selected)
		$Container/MarginContainer/Sidebar/ShopPanel.add_child(sfb)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# TODO CONNECT SELECT FISH
# called by the sidebar's fish_purchase_requested signal
func _on_fish_selected(species: FishSpecies) -> void:
	selected_fish = species  # don't spend yet — wait for placement
	print("set selected fish")

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		_drop_food(event.position)
		print("dropping food")
		_place_plant(event.position)
	elif (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT):
		_place_fish(event.position)

func _make_placeholder_plantspecies() -> PlantSpecies:
	var species := PlantSpecies.new()
	species.co2_consumption = 2
	species.o2_production = 2
	return species

func _place_fish(pos: Vector2) -> void:
	if selected_fish:
		if not Aquarium._updateMoney(-selected_fish.cost):
			
			return
		var fish := fish_scene.instantiate()
		fish.species = selected_fish
		$EntityContainer.add_child(fish)
		fish.global_position = pos
		fish.reset_target()
		

func _place_plant(pos: Vector2) -> void:
	#if not Aquarium._updateMoney(pending_fish.cost):
		#return
	if pos.x < PLANT_MIN_X \
			or pos.x > PLANT_MAX_X \
			or pos.y < PLANT_MIN_Y \
			or pos.y > PLANT_MAX_Y:
		print("Plants can only be placed in the substrate.")
		return
		
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
