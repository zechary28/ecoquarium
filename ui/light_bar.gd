extends HBoxContainer

@onready var button_down: Button = $ButtonDown
@onready var level_label: Label = $Label
@onready var button_up: Button = $ButtonUp

const LEVEL_COLORS := [
	Color(0.48, 0.68, 0.88),
	Color(0.56, 0.74, 0.91),
	Color(0.68, 0.82, 0.94),
	Color(0.88, 0.91, 0.82),
	Color(1.0, 0.88, 0.58),
	Color(1.0, 0.78, 0.34),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Aquarium.light_changed.connect(_on_light_changed)
	_refresh(Aquarium.lightLevel)

func _on_button_up_pressed() -> void:
	var next_level := mini(5, Aquarium.lightLevel + 1)
	if next_level != Aquarium.lightLevel:
		Aquarium.set_light_level(next_level)
		AudioManager.play_light_changed()

func _on_button_down_pressed() -> void:
	var next_level := maxi(0, Aquarium.lightLevel - 1)
	if next_level != Aquarium.lightLevel:
		Aquarium.set_light_level(next_level)
		AudioManager.play_light_changed()


func _on_light_changed(new_level: int) -> void:
	_refresh(new_level)


func _refresh(level: int) -> void:
	var clamped_level := clampi(level, 0, 5)
	level_label.text = "LIGHT  %d/5" % clamped_level
	level_label.self_modulate = LEVEL_COLORS[clamped_level]
	button_down.disabled = clamped_level == 0
	button_up.disabled = clamped_level == 5
	tooltip_text = "Aquarium light level: %d of 5" % clamped_level
