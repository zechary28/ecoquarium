extends Node2D

@export var fish_scene: PackedScene
@export var plant_scene: PackedScene
@export var food_effect_scene: PackedScene
@export var sprite_frames: SpriteFrames

var selected_fish: FishSpecies = null
var selected_plant: PlantSpecies = null
var shop_selection_group := ButtonGroup.new()
const CATALOG := preload("res://resources/species_catalog.tres")
const SELECT_FISH_BUTTON_SCENE := preload("res://ui/select_fish_button.tscn")
const SELECT_PLANT_BUTTON_SCENE := preload("res://ui/select_plant_button.tscn")
const SPECIES_STATUS_BAR := preload("res://ui/species_status_bar.tscn")

const PLANT_MIN_Y := 535.0
const PLANT_MAX_Y := 580.0
const PLANT_MIN_X := 40.0
const PLANT_MAX_X := 1100.0
const FOOD_COST: float = 3.0
const FOOD_PER_DROP: float = 8.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop_selection_group.allow_unpress = true

	for species in CATALOG.plant_species:
		var plant_button := SELECT_PLANT_BUTTON_SCENE.instantiate()
		plant_button.species = species
		plant_button.get_node("IconButton").button_group = shop_selection_group
		plant_button.plant_selection_changed.connect(_on_plant_selection_changed)
		$Container/MarginContainer/Sidebar/ShopPanel.add_child(plant_button)

	#load all available fish species
	for species in CATALOG.fish_species:
		var sfb = SELECT_FISH_BUTTON_SCENE.instantiate()
		sfb.species = species
		sfb.get_node("IconButton").button_group = shop_selection_group
		sfb.fish_selection_changed.connect(_on_fish_selection_changed)
		$Container/MarginContainer/Sidebar/ShopPanel.add_child(sfb)

	_refresh_species_status_bars()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# TODO CONNECT SELECT FISH
# called by the sidebar's fish_purchase_requested signal
func _on_fish_selection_changed(species: FishSpecies, is_selected: bool) -> void:
	if is_selected:
		selected_fish = species
		selected_plant = null
	elif selected_fish == species:
		selected_fish = null


func _on_plant_selection_changed(species: PlantSpecies, is_selected: bool) -> void:
	if is_selected:
		selected_plant = species
		selected_fish = null
	elif selected_plant == species:
		selected_plant = null


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or not event.pressed:
		return

	if event.button_index == MOUSE_BUTTON_RIGHT:
		_drop_food(event.position)
		return

	if event.button_index == MOUSE_BUTTON_LEFT:
		if selected_fish != null:
			_place_fish(event.position)
		elif selected_plant != null:
			_place_plant(event.position)

func _place_fish(pos: Vector2) -> void:
	if selected_fish:
		if not Aquarium._updateMoney(-selected_fish.cost):
			print("Not enough money for %s." % selected_fish.display_name)
			return
		var fish := fish_scene.instantiate()
		fish.species = selected_fish
		fish.died.connect(_on_fish_died)
		$EntityContainer.add_child(fish)
		fish.global_position = pos
		fish.reset_target()
		_refresh_species_status_bars()


func _on_fish_died(_fish: Fish) -> void:
	# The fish removes itself from the active group before emitting this signal.
	call_deferred("_refresh_species_status_bars")


func _refresh_species_status_bars() -> void:
	var counts: Dictionary = {}
	for fish in get_tree().get_nodes_in_group("fish"):
		if fish is Fish and fish.species != null:
			counts[fish.species] = counts.get(fish.species, 0) + 1

	var status_list := $Container/MarginContainer2/SpeciesStatusBars
	for row in status_list.get_children():
		row.queue_free()

	# Catalog order keeps the list stable as fish are added and removed.
	for species in CATALOG.fish_species:
		if not counts.has(species):
			continue
		var status_row := SPECIES_STATUS_BAR.instantiate()
		status_row.species = species
		status_row.fish_count = counts[species]
		status_list.add_child(status_row)

func _place_plant(pos: Vector2) -> void:
	if selected_plant == null:
		return

	if pos.x < PLANT_MIN_X \
			or pos.x > PLANT_MAX_X \
			or pos.y < PLANT_MIN_Y \
			or pos.y > PLANT_MAX_Y:
		print("Plants can only be placed in the substrate.")
		return

	var plant_species := selected_plant
	if not Aquarium._updateMoney(-plant_species.cost):
		print("Not enough money for a plant.")
		return

	var plant := plant_scene.instantiate()
	plant.species = plant_species
	$EntityContainer.add_child(plant)
	plant.global_position = pos

func _drop_food(pos: Vector2) -> void:
	if not Aquarium._updateMoney(-FOOD_COST):
		print("Not enough money for food.")
		return

	Aquarium._updateFood(FOOD_PER_DROP)

	var effect := food_effect_scene.instantiate()
	$EffectContainer.add_child(effect)
	effect.global_position = pos
