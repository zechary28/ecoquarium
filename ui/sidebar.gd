extends VBoxContainer

signal fish_purchase_requested

const CATALOG := preload("res://resources/species_catalog.tres")
const SELECT_FISH_BUTTON_SCENE := preload("res://ui/select_fish_button.tscn")

@onready var money_value: Label = $TopSpacer/EconomyPanel/EconomyContent/MoneyValue
@onready var beauty_value: Label = $TopSpacer/EconomyPanel/EconomyContent/BeautyValue

func _ready() -> void:
	#load all available fish species
	#for species in CATALOG.fish_species:
		#var sfb = SELECT_FISH_BUTTON_SCENE.instantiate()
		#sfb.species = species
		#$ShopPanel.add_child(sfb)
	#for button in $ShopPanel.get_children():
		#if button.has_signal("purchase_requested"):
			#button.purchase_requested.connect(_on_purchase_requested)
	Aquarium.stats_changed.connect(_on_stats_changed)
	Aquarium.cash_changed.connect(_on_cash_changed)
	$StatusPanel/ProgressBarO2.value = Aquarium.O2Level
	$StatusPanel/ProgressBarCO2.value = Aquarium.CO2Level
	$StatusPanel/ProgressBarFood.value = Aquarium.FoodLevel
	money_value.text = str(int(Aquarium.Money))
	beauty_value.text = str(int(Aquarium.Beauty))

func _on_purchase_requested(species: FishSpecies) -> void:
	fish_purchase_requested.emit(species)

func _on_stats_changed() -> void:
	$StatusPanel/ProgressBarO2.value = Aquarium.O2Level
	$StatusPanel/ProgressBarCO2.value = Aquarium.CO2Level
	$StatusPanel/ProgressBarFood.value = Aquarium.FoodLevel
	beauty_value.text = str(int(Aquarium.Beauty))
	money_value.text = str(int(Aquarium.Money))

func _on_cash_changed(new_cash: float) -> void:
	money_value.text = str(int(new_cash))
	money_value.self_modulate = Color(1.25, 1.12, 0.75, 1.0)
	var tween := create_tween()
	tween.tween_property(money_value, "self_modulate", Color.WHITE, 0.2)
