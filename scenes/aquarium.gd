extends Node2D

signal stats_changed
signal cash_changed(new_cash: int)

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
	print("O2 level changed by %d to: %d" % [o2_delta, O2Level])
	print("CO2 level changed by %d to: %d" % [co2_delta, CO2Level])
	print("Food level changed by %d to: %d" % [food_delta, FoodLevel])
	#score = total_beauty

	#Money += score * REVENUE_MULTIPLIER * TICK_INTERVAL
	cash_changed.emit()
	stats_changed.emit()
