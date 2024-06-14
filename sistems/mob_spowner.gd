class_name MobSpawner
extends Node2D

@export var creatures: Array[PackedScene]

@onready var path_follow_2d: PathFollow2D = %PathFollow2D

var mobs_per_minute: float = 30.0
var cooldown: float = 0.0

func _process(delta: float) ->void:
	# Temporizador(cooldown)
	cooldown -= delta
	if cooldown > 0: return
	# Frequencia (monstros por segundo ou por minutos) -> 60 mostros por minuto = 1 mostro por segundo / 120 mostros por minutos = 2 mostros por segundo
	# Intervalos em segundo entre criação de mostros => 60 / frequencia
	var interval = 60 / mobs_per_minute
	cooldown = interval
	
	# Checar se o ponto é válido
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1000
	var result: Array = world_state.intersect_point(parameters, 1)
	if not result.is_empty(): return
	
	# Perguntar para o jogo se o ponto tem colisão
	
	# Instanciar uma criatura aleatória
	# Pegar uma criatura aleatória
	# pegar um ponto 
	# Instanciar a cena
	# Posicionar
	var index = randi_range(0, creatures.size() - 1)
	var creature_scene = creatures[index]
	var creature = creature_scene.instantiate()
	get_parent().add_child(creature)
	
func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf() # random float
	return path_follow_2d.global_position

