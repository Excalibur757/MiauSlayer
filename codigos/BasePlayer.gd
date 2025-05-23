extends CharacterBody2D

class_name BasePlayer

@export var movement_speed: float = 100
@export var roll_speed: float = 250
@export var roll_duration: float = 0.3
@export var roll_cooldown: float = 1.0
@export var attack_cooldown: float = 0.5
@export var max_health: int = 5
@export var input_prefix: String = ""  # usado para diferenciar os inputs dos players
var is_attacking: bool = false

@onready var collider = $CollisionShape2D
@onready var sprite = $AnimatedSprite2D
@onready var walk_timer = $WalkTimer
var SwordScene = preload("res://Nodes/attack.tscn")

var current_health: int
var is_dead: bool = false
var can_attack: bool = true
var can_roll: bool = true
var is_rolling: bool = false
var roll_direction: Vector2 = Vector2.ZERO

signal health_changed(new_health)
signal player_died

func _ready():
	current_health = max_health

func _physics_process(_delta):
	#check_level_up()
	if is_rolling:
		velocity = roll_direction * roll_speed
	else:
		movement()

	move_and_slide()

func _input(_event):
	if Input.is_action_just_pressed(input_prefix + "attack"):
		attack()
	elif Input.is_action_just_pressed(input_prefix + "roll"):
		roll()

func movement():
	var input_vector = Vector2(
		Input.get_action_strength(input_prefix + "right") - Input.get_action_strength(input_prefix + "left"),
		Input.get_action_strength(input_prefix + "down") - Input.get_action_strength(input_prefix + "up")
	)

	velocity = input_vector * movement_speed
	roll_direction = input_vector

	if is_attacking:
		return  # Atacando, não troca animação, mas movimento ainda acontece

	if input_vector.x > 0:
		sprite.play("walk_right")
	elif input_vector.x < 0:
		sprite.play("walk_left")
	elif input_vector == Vector2.ZERO:
		sprite.play("idle")


func attack():
	if not can_attack or is_dead:
		return

	can_attack = false
	is_attacking = true
	sprite.play("attack")

	var sword = SwordScene.instantiate()
	get_tree().current_scene.add_child(sword)

	var direction = get_attack_direction()
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT

	sword.global_position = global_position + direction.normalized() * 20
	sword.look_at(global_position + direction)

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	is_attacking = false



func get_attack_direction() -> Vector2:
	var joy_direction = Vector2(
		Input.get_action_strength(input_prefix + "aim_right") - Input.get_action_strength(input_prefix + "aim_left"),
		Input.get_action_strength(input_prefix + "aim_down") - Input.get_action_strength(input_prefix + "aim_up")
	)

	if joy_direction.length() > 0.1:
		return joy_direction.normalized()

	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	return mouse_direction

func roll():
	if not can_roll or is_dead or roll_direction == Vector2.ZERO:
		return

	is_rolling = true
	can_roll = false
	await get_tree().create_timer(roll_duration).timeout
	is_rolling = false
	await get_tree().create_timer(roll_cooldown).timeout
	can_roll = true

func take_damage(amount: int = 1, from_position: Vector2 = Vector2.ZERO):
	if is_dead:
		return
	current_health -= amount
	current_health = max(current_health, 0)
	emit_signal("health_changed", current_health)
	if $status:
		$status.visible = true  # Garante que apareça
		$status.play("damage")
	if current_health <= 0:
		emit_signal("player_died")
		die()

		
func die():
	is_dead = true
	set_physics_process(false)
	set_process_input(false)
	GameManager.player_died()

	# Desativa colisor corretamente
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)

	# Alternativamente, zera camada/máscara
	collision_layer = 0
	collision_mask = 0

	sprite.modulate = Color(1, 1, 1, 0.5)  # Visual de "morto"


func play_level_up_animation():
	if $status:
		$status.visible = true
		$status.play("upgrade")
