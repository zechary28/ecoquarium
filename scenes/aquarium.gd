extends Node2D

var lightLevel: int = 3
var O2Level: int = 50
var CO2Level: int = 50
var FoodLevel: int = 0
var Money: int = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _increaseLight() -> void:
	lightLevel = min(5, lightLevel + 1)
	print("Light level increased to: %d" % lightLevel)

func _decreaseLight() -> void:
	lightLevel = max(0, lightLevel - 1)
	print("Light level decreased to: %d" % lightLevel)

func _updateO2(change: int) -> void:
	O2Level += change
	print("O2 level changed by %d to: %d" % [change, O2Level])

func _updateCO2(change: int) -> void:
	CO2Level += change
	print("CO2 level changed by %d to: %d" % [change, CO2Level])

func _updateFood(change: int) -> void:
	FoodLevel += change
	print("Food level changed by %d to: %d" % [change, FoodLevel])

func _updateMoney(change: int) -> bool:
	if (Money + change < 0):
		return false
	else:
		Money += change
		print("Money changed by %d to: %d" % [change, Money])
		return true

func _on_timer_timeout() -> void:
	print("Timeout")
	#_updateO2(1)
	#_updateCO2(1)
	#_updateFood(1)
