extends Node

@export var speed: float = 1.0

var enemy: Enemy
var sprite: AnimatedSprite2D


func _ready() -> void:
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")

func _physics_process(delta: float) -> void:
		# Ignorar o gamer over
	if GameManager.is_gamer_over: return
	
	
	var player_position = GameManager.player_position
	var difference = player_position - enemy.position
	var input_vector = difference.normalized()
	
	# Input vector = Vector2 que varia entre -1 e 1 em ambos os eixos
	enemy.velocity = input_vector * speed * 100
	enemy.move_and_slide()
	
	# Girar sprite
	if input_vector.x > 0:
		# Desmarcar o flip_h do Sprit2D
		sprite.flip_h = false
	elif input_vector.x < 0:
		# Marcar o flip_h do Sprit2D
		sprite.flip_h = true
