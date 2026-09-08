func _ready() -> void:
	for button in $ShopPanel.get_children():
		if button.has_signal("purchase_requested"):
			button.purchase_requested.connect(_on_purchase_requested)

func _on_purchase_requested(species: FishSpecies) -> void:
	fish_purchase_requested.emit(species)

func _on_stats_changed() -> void:
	o2_bar.value = Aquarium.o2
	co2_bar.value = Aquarium.co2
	food_bar.value = Aquarium.food
