extends VBoxContainer

signal fish_purchase_requested

const CATALOG := preload("res://resources/species_catalog.tres")
const SELECT_FISH_BUTTON_SCENE := preload("res://ui/select_fish_button.tscn")

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
	$ProgressBarO2.value = Aquarium.O2Level
	$ProgressBarCO2.value = Aquarium.CO2Level
	$ProgressBarFood.value = Aquarium.FoodLevel
	$LabelMoney.text = "Money: " + str(Aquarium.Money)

func _on_purchase_requested(species: FishSpecies) -> void:
	fish_purchase_requested.emit(species)

func _on_stats_changed() -> void:
	$ProgressBarO2.value = Aquarium.O2Level
	$ProgressBarCO2.value = Aquarium.CO2Level
	$ProgressBarFood.value = Aquarium.FoodLevel

func _on_cash_changed() -> void:
	$LabelMoney.text = "Money: " + str(Aquarium.Money)
