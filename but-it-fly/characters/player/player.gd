class_name Player
extends CharacterBody2D

# Variáveis do personagem
var speed = 300
var jump_force = 200
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Variáveis do pulo
var max_jump_time = 0.25
var jump_time = 0.0
var is_jumping = true

# Variáveis de ataque
var is_attacking = false
var attack_cooldown = 0.5
# Hitbox do ataque
@onready var attack_hitbox: Hitbox = $Hitbox

# Direção para qual o personagem está olhando
var looking_at:Vector2 = Vector2.RIGHT



func _ready() -> void:
	attack_hitbox.monitoring = false
	attack_hitbox.monitorable = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		is_jumping = false
	
	if Input.is_action_pressed("move_left"):
		velocity.x = speed * -1
		looking_at = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		velocity.x = speed
		looking_at = Vector2.RIGHT
	elif Input.is_action_pressed("look_down"):
		looking_at = Vector2.DOWN
	elif Input.is_action_pressed("look_up"):
		looking_at = Vector2.UP
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if Input.is_action_just_pressed("jump") and not is_jumping:
		is_jumping = true
		jump_time = 0.0
		velocity.y = jump_force * -1
	elif Input.is_action_pressed("jump") and is_jumping:
		if jump_time <= max_jump_time:
			jump_time += delta
			velocity.y -= jump_force * delta * 10
	
	if Input.is_action_just_pressed("sword_slash") and not is_attacking:
		is_attacking = true
		_attack()
	
	_update_attack_hitbox_direction()
	move_and_slide()

func _attack():
	# Ativa a detecção de outras áreas
	attack_hitbox.monitoring = true
	attack_hitbox.monitorable = true
	attack_hitbox.modulate = Color(1.0, 1.0, 2.0)  # Só pra testar, substituir pela animação padrão
	# Deixa as áreas ativadas por esse tempo (duração do ataque) e depois desativa
	await get_tree().create_timer(0.25).timeout
	attack_hitbox.monitoring = false
	attack_hitbox.monitorable = false
	# Aplica o cooldown para impedir múltiplos ataques
	await get_tree().create_timer(attack_cooldown).timeout
	is_attacking = false
	attack_hitbox.modulate = Color(1.0, 1.0, 1.0) # Só pra testar, substituir pela animação de ataque

func _update_attack_hitbox_direction():
	match looking_at:
		Vector2.LEFT:
			attack_hitbox.position = Vector2(-50, 0)
			attack_hitbox.rotation = deg_to_rad(0)
		Vector2.RIGHT:
			attack_hitbox.position = Vector2(50, 0)
			attack_hitbox.rotation = deg_to_rad(0)
		Vector2.UP:
			attack_hitbox.position = Vector2(0, -50)
			attack_hitbox.rotation = deg_to_rad(90)
		Vector2.DOWN:
			attack_hitbox.position = Vector2(0, 50)
			attack_hitbox.rotation = deg_to_rad(90)
		
