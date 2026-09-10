#select_fish_button.gd

extends VBoxContainer

@export var species: FishSpecies

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LabelName.text = species.display_name if species else "???"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
