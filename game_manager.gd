extends Node

signal game_over

var player: Player
var player_position: Vector2
var is_gamer_over: bool = false

var time_elapsed: float = 0.0
var time_elapsed_string: String
var meat_count: int = 0
var monsters_defeated_count: int = 0

func _process(delta: float):
	time_elapsed += delta
	var time_elepsed_in_secund: int = floori(time_elapsed)
	var secunds: int = time_elepsed_in_secund % 60
	var minutes: int = time_elepsed_in_secund / 60
	time_elapsed_string = "%02d:%02d" % [minutes,secunds]

func end_game():
	if is_gamer_over: return
	is_gamer_over = true
	game_over.emit()

func reset():
	player = null
	player_position = Vector2(0,0)
	is_gamer_over = false
	
	time_elapsed = 0.0
	time_elapsed_string = ""
	meat_count = 0
	monsters_defeated_count = 0
	
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)


