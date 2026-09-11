extends Node2D

signal stats_changed
signal cash_changed(new_cash: float)

var lightLevel: int = 3
var O2Level: float = 50
var CO2Level: float = 50
var FoodLevel: float = 25.0
var Money: float = 60.0
var Beauty: int = 0
const REVENUE_MULTIPLIER: float = 0.06

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _updateO2(change: int) -> void:
	O2Level += change
	print("O2 level changed by %d to: %d" % [change, O2Level])

func _updateCO2(change: int) -> void:
	CO2Level += change
	print("CO2 level changed by %d to: %d" % [change, CO2Level])

func _updateFood(change: float) -> void:
	FoodLevel = clampf(FoodLevel + change, 0.0, 100.0)
	print("Food level: %.1f" % FoodLevel)
	stats_changed.emit()

func _updateMoney(change: float) -> bool:
	if Money + change < 0.0:
		return false

	Money += change
	cash_changed.emit(Money)
	return true

func _on_timer_timeout() -> void:
	print("Timeout")
	var o2_delta := 0
	var co2_delta := 0
	var food_delta := 0
	var total_beauty := 0
 
	# Every plant, wherever it's parented, as long as it's tagged "plants".
	for plant in get_tree().get_nodes_in_group("plants"):
		var contrib: Dictionary = plant.get_contribution(lightLevel, CO2Level)
		o2_delta += contrib.get("o2_produced", 0)
		co2_delta -= contrib.get("co2_consumed", 0)
 
	# Every fish, same idea. Both loops read the SAME o2/food values read
	# at the top of this function — no fish's contribution is computed
	# against numbers another fish already changed this tick.
	for fish in get_tree().get_nodes_in_group("fish"):
		var contrib: Dictionary = fish.get_contribution(O2Level, FoodLevel)
		o2_delta -= contrib.get("o2_consumed", 0)
		co2_delta += contrib.get("co2_produced", 0)
		food_delta -= contrib.get("food_consumed", 0)
		total_beauty += contrib.get("beauty", 0)
 
	# Apply everything at once, only after every contribution is collected.
	O2Level = clampf(O2Level + o2_delta, 0, 100)
	CO2Level = clampf(CO2Level + co2_delta, 0, 100)
	FoodLevel = clampf(FoodLevel + food_delta, 0, 100)
	Beauty = total_beauty
	print("O2 level changed by %d to: %d" % [o2_delta, O2Level])
	print("CO2 level changed by %d to: %d" % [co2_delta, CO2Level])
	print("Food level changed by %d to: %d" % [food_delta, FoodLevel])

	Money += total_beauty * REVENUE_MULTIPLIER
	cash_changed.emit(Money)
	stats_changed.emit()
