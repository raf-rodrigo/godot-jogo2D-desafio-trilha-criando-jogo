extends CanvasLayer

@onready var time_label: Label = %TimeLabel
@onready var meat_label: Label = $Banner/MeatLabel
@onready var gold_label: Label = %Banner/GoldLabel

func _ready():
	meat_label.text = str(GameManager.meat_count)

func _process(delta: float):
	#Update time
	time_label.text = GameManager.time_elapsed_string
	meat_label.text = str(GameManager.meat_count)

