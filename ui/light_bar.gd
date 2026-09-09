extends HBoxContainer

var lightLevelControl = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_down_pressed() -> void:
	Aquarium.lightLevel = min(5, Aquarium.lightLevel + 1)
	print("Light level increased to: %d" % Aquarium.lightLevel)

func _on_button_up_pressed() -> void:
	Aquarium.lightLevel = max(0, Aquarium.lightLevel - 1)
	print("Light level decreased to: %d" % Aquarium.lightLevel)
