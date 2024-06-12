class_name Player
extends CharacterBody2D

@export var speed: float = 3.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer 
@onready var sprite: Sprite2D = $sprite2D

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_move_left: bool = false
var is_move_right: bool = true
var is_attack: bool = false
var is_flip_h: bool = false
var attack_cooldown: float = 0.0

func _process(delta: float) -> void:
	# Chamar a função que captura o input vector
	read_input()
	
	# A cada frame do jogo diminir a variável cooldown
	# 0.6 - 0.16 = 0.584
	update_attack_cooldown(delta)
	
	# Tocar animação
	play_run_idle_animation()
	
	# Girar sprite
	spin_sprite()
	
	if Input.is_action_just_pressed("attack"):
		attack()

func _physics_process(delta: float) -> void:
	# Modificar a velocidade
	var target_velocity = input_vector * speed * 100
	if is_attack:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.08)
	move_and_slide()

func spin_sprite():
	if input_vector.x > 0:
		# Desmarcar o flip_h do Sprit2D
		sprite.flip_h = false
	elif input_vector.x < 0:
		# Marcar o flip_h do Sprit2D
		sprite.flip_h = true

func read_input() ->void:
	# Obter o input do vetor
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down")
	print(input_vector)
	# Apagar deadzone do input vector
	var deadzone = 0.15
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0.0
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0.0
	
	# Atualizazr o is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func attack() -> void:
	if is_attack: 
		return
		
	# Tocar animação
	if input_vector.x < 0:
		animation_player.play("attack_side_1")
	elif input_vector.x > 0:
		animation_player.play("attack_side_2")
	elif input_vector.x == 0:
		animation_player.play("attack_side_2")
	elif input_vector == Vector2(0,-1):
		animation_player.play("attack_up_1")
	elif input_vector == Vector2(0,1):
		animation_player.play("attack_down_2")
	elif input_vector == Vector2(0.707107,0.707107):
		animation_player.play("attack_down_1")
	elif input_vector == Vector2(-0.707107,0.707107):
		animation_player.play("attack_down_1")
	elif input_vector == Vector2(-0.707107,-0.707107):
		animation_player.play("attack_up_2")
	elif input_vector == Vector2(0.707107,-0.707107):
		animation_player.play("attack_up_2")
	
	# Configurar temporizador do ataque
	attack_cooldown = 0.6
	
	# Marcar ataque
	is_attack = true

func play_run_idle_animation() -> void:
	if was_running != is_running:
		if is_running:
			animation_player.play("running")
		else:
			animation_player.play("idle")

func update_attack_cooldown(delta: float) -> void:
	if is_attack:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attack = false
			is_running = false
			animation_player.play("idle")
