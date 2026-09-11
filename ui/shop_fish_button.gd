extends Button

@export var species: FishSpecies
signal purchase_requested(species: FishSpecies)

func _ready() -> void:
	text = species.display_name if species else "???"
	pressed.connect(func(): purchase_requested.emit(species))
