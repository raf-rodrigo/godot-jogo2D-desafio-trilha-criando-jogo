extends Node2D

@export var creatures: Array[PackedScene]
@export var mobs_per_minute: float = 60.0

@onready var path_follow_2d: PathFollow2D = %PathFollow2D

var cooldown: float = 0.0

func _process(delta: float) ->void:
	# Temporizador(cooldown)
	cooldown -= delta
	if cooldown > 0: return
	# Frequencia (monstros por segundo ou por minutos) -> 60 mostros por minuto = 1 mostro por segundo / 120 mostros por minutos = 2 mostros por segundo
	# Intervalos em segundo entre criação de mostros => 60 / frequencia
	var interval = 60 / mobs_per_minute
	cooldown = interval
	
	# Instanciar uma criatura aleatória
	# Pegar uma criatura aleatória
	# pegar um ponto 
	# Instanciar a cena
	# Posicionar
	var index = randi_range(0, creatures.size() - 1)
	var creature_scene = creatures[index]
	var creature = creature_scene.instantiate()
	creature.global_position = get_point()
	get_parent().add_child(creature)
	
func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf() # random float
	return path_follow_2d.global_position

