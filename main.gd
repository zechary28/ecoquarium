extends Node2D

@export var fish_scene: PackedScene
@export var plant_scene: PackedScene
@export var food_effect_scene: PackedScene

var pending_fish: FishSpecies = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("I am main")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# called by the sidebar's fish_purchase_requested signal
func _on_fish_purchase_requested(species: FishSpecies) -> void:
	pending_fish = species  # don't spend yet — wait for placement

func _unhandled_input(event: InputEvent) -> void:
	#if not (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		#return
#
	#if pending_fish:
		#_place_fish(event.position)
	#else:
		#_drop_food(event.position)
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		_drop_food(event.position)
		print("dropping food")
	elif (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT):
		_place_fish(event.position)

func _make_placeholder_species() -> FishSpecies:
	var species := FishSpecies.new()
	species.o2_consumption = 2
	species.food_consumption = 1
	species.co2_production = 2
	species.aesthetic_value = 5
	return species

func _place_fish(pos: Vector2) -> void:
	#if not Aquarium._updateMoney(pending_fish.cost):
		#return
	var fish := fish_scene.instantiate()
	fish.species = _make_placeholder_species()
	#fish.species = pending_fish
	fish.position = pos
	$EntityContainer.add_child(fish)
	pending_fish = null

func _drop_food(pos: Vector2) -> void:
	Aquarium._updateFood(5.0)
	var effect := food_effect_scene.instantiate()
	effect.position = pos
	$EffectContainer.add_child(effect)
