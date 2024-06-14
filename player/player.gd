class_name Player 
extends CharacterBody2D

@export_category("Movement")
@export var speed: float = 3.0

@export_category("Sword")
@export var sword_damage: int = 1

@export_category("Ritual")
@export var ritual_damage: int = 2
@export var ritual_interval: float = 30.0
@export var ritual_scene: PackedScene

@export_category("Life")
@export var health: float = 100
@export var max_health: float = 100
@export var death_prefab: PackedScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer 
@onready var sprite: Sprite2D = $sprite2D
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea
@onready var health_progressBar: ProgressBar = $ProgressBar

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_move_left: bool = false
var is_move_right: bool = true
var is_attack: bool = false
var is_flip_h: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var ritual_cooldown: float = 30.0

signal meat_collect(value: int)
signal gold_collect(value: int)

func _ready():
	GameManager.player = self
	meat_collect.connect(func(): GameManager.meat_count += 1)

func _process(delta: float) -> void:
	# Injetando a posição do meu player
	GameManager.player_position = position
	# Chamar a função que captura o input vector
	read_input()
	
	# A cada frame do jogo diminir a variável cooldown
	# 0.6 - 0.16 = 0.584
	update_attack_cooldown(delta)
	
	# Tocar animação
	play_run_idle_animation()
	
	# Girar sprite
	if not is_attack:
		spin_sprite()
	
	if Input.is_action_just_pressed("attack"):
		attack()
		
	# Processar dano
	update_hitbox_detection(delta)
	
	# Ritual
	update_ritual(delta)
	
	# Atualizar Health Bar
	health_progressBar.max_value = max_health
	health_progressBar.value = health

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
	# attack_side_1
	# attack_side_2
	# Tocar animação do ataque
	animation_player.play("attack_side_1")
	attack_cooldown = 0.6
	
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

func deal_damage_to_enemies() ->void:
	# Acessar todos os inimigos
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var diretion_to_enemy = (enemy.position - position).normalized()
			var attack_diretion: Vector2
			if sprite.flip_h:
				attack_diretion = Vector2.LEFT
			else:
				attack_diretion = Vector2.RIGHT
			var dot_product = diretion_to_enemy.dot(attack_diretion)
			if dot_product >= 0.3:
				enemy.damage(sword_damage)

func update_hitbox_detection(delta: float) -> void:
	# Temprizador
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	
	# Frequencia (2x por seg)
	hitbox_cooldown = 0.5
	
	# HitBoxArea
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = 1
			damage(damage_amount)

func damage(amount: int) -> void:
	if health <= 0: return
	
	health -= amount
	
	# Piscar enemies
	modulate = Color.RED
	var tween =	create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	# Processa morte
	if health <= 0:
		die()

func die() -> void:
	GameManager.end_game()
	
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	queue_free()

func heal(amount: int) -> void:
	health += amount
	if health >= max_health:
		health = max_health

func update_ritual(delta: float) -> void:
	# Atualizar temporizador
	ritual_cooldown -= delta
	if ritual_cooldown > 0: 
		return
	ritual_cooldown = ritual_interval
	
	# criar o ritual
	var ritual = ritual_scene.instantiate()
	ritual.damage_amount = ritual_damage
	add_child(ritual)
