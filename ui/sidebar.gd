extends VBoxContainer

signal fish_purchase_requested

func _ready() -> void:
	#for button in $ShopPanel.get_children():
		#if button.has_signal("purchase_requested"):
			#button.purchase_requested.connect(_on_purchase_requested)
	Aquarium.stats_changed.connect(_on_stats_changed)
	Aquarium.cash_changed.connect(_on_cash_changed)
	$ProgressBarO2.value = Aquarium.O2Level
	$ProgressBarCO2.value = Aquarium.CO2Level
	$ProgressBarFood.value = Aquarium.FoodLevel
	$LabelMoney.text = str(Aquarium.Money)

func _on_purchase_requested(species: FishSpecies) -> void:
	fish_purchase_requested.emit(species)

func _on_stats_changed() -> void:
	$ProgressBarO2.value = Aquarium.O2Level
	$ProgressBarCO2.value = Aquarium.CO2Level
	$ProgressBarFood.value = Aquarium.FoodLevel

func _on_cash_changed() -> void:
	$LabelMoney.text = str(Aquarium.Money)
