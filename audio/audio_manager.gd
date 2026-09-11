extends Node

@export_category("Music and ambience")
@export var aquarium_music: AudioStream
@export var water_ambience: AudioStream

@export_category("Interface sounds")
@export var ui_hover_sfx: AudioStream
@export var ui_click_sfx: AudioStream

@export_category("Gameplay sounds")
@export var fish_placed_sfx: AudioStream
@export var plant_placed_sfx: AudioStream
@export var food_dropped_sfx: AudioStream
@export var light_changed_sfx: AudioStream
@export var purchase_denied_sfx: AudioStream
@export var fish_death_sfx: AudioStream

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var ambience_player: AudioStreamPlayer = $AmbiencePlayer


func _ready() -> void:
	# Starting from the autoload keeps music alive and independent of scene changes.
	start_aquarium_audio()


func start_aquarium_audio() -> void:
	_play_loop(music_player, aquarium_music)
	_play_loop(ambience_player, water_ambience)


func stop_aquarium_audio() -> void:
	music_player.stop()
	ambience_player.stop()


func play_ui_hover() -> void:
	_play_one_shot(ui_hover_sfx, &"UI", -4.0, 0.02)


func play_ui_click() -> void:
	_play_one_shot(ui_click_sfx, &"UI", -2.0, 0.02)


func play_fish_placed() -> void:
	_play_one_shot(fish_placed_sfx, &"SFX", 0.0, 0.05)


func play_plant_placed() -> void:
	_play_one_shot(plant_placed_sfx, &"SFX", 0.0, 0.04)


func play_food_dropped() -> void:
	_play_one_shot(food_dropped_sfx, &"SFX", -1.0, 0.08)


func play_light_changed() -> void:
	_play_one_shot(light_changed_sfx, &"UI", -2.0, 0.02)


func play_purchase_denied() -> void:
	_play_one_shot(purchase_denied_sfx, &"UI", 0.0, 0.0)


func play_fish_death() -> void:
	_play_one_shot(fish_death_sfx, &"SFX", -2.0, 0.03)


func set_bus_volume(bus_name: StringName, linear_volume: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index < 0:
		return
	var clamped_volume := clampf(linear_volume, 0.0, 1.0)
	AudioServer.set_bus_mute(bus_index, clamped_volume <= 0.0)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(maxf(clamped_volume, 0.0001)))


func _play_loop(player: AudioStreamPlayer, stream: AudioStream) -> void:
	if stream == null:
		return
	if player.playing:
		return

	# Duplicate the imported resource so loop settings only affect this player.
	var looping_stream := stream.duplicate()
	if looping_stream is AudioStreamWAV:
		looping_stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	elif looping_stream is AudioStreamOggVorbis:
		looping_stream.loop = true
	elif looping_stream is AudioStreamMP3:
		looping_stream.loop = true

	player.stream = looping_stream
	player.play()


func _play_one_shot(
	stream: AudioStream,
	bus_name: StringName,
	volume_db: float,
	pitch_variation: float
) -> void:
	if stream == null:
		return

	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = bus_name
	player.volume_db = volume_db
	player.pitch_scale = randf_range(1.0 - pitch_variation, 1.0 + pitch_variation)
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()
