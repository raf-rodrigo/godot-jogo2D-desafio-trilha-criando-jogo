extends CanvasLayer

@onready var time_label: Label = %TimeLabel
@onready var meat_label: Label = $Banner/MeatLabel
@onready var gold_label: Label = %Banner/GoldLabel

var time_elapsed: float = 0.0
var meat_count: int = 0

func _ready():
	GameManager.player.meat_collect.connect(on_meat_collect)
	meat_label.text = str(meat_count)

func _process(delta: float):
	time_elapsed += delta
	var time_elepsed_in_secund: int = floori(time_elapsed)
	var secunds: int = time_elepsed_in_secund % 60
	var minutes: int = time_elepsed_in_secund / 60
	time_label.text = "%02d:%02d" % [minutes,secunds]

func on_meat_collect(regeneration_value: int) -> void:
	meat_count += 1
	meat_label.text = str(meat_count)
