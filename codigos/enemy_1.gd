extends CharacterBody2D

var xp = preload("res://Nodes/xp.tscn")

@export var movement_speed = 50
@onready var sprite = $Sprite2D
@onready var walkTimer = $WalkTimer
@export var max_health: int = 3
var current_health: int

func _ready():
	current_health = max_health

func take_damage2():
	die()

func die():
	
	var new_xp = xp.instantiate()
	new_xp.global_position = self.global_position
	print("DROUPO XPPP")
	get_tree().current_scene.add_child(new_xp)
	
	queue_free()

func get_closest_alive_player() -> Node2D:
	var players = get_tree().get_nodes_in_group("Player")
	var closest_player = null
	var closest_distance = INF

	for p in players:
		if not is_instance_valid(p):
			continue
		if not "is_dead" in p:
			continue
		if p.is_dead:
			continue

		var distance = p.global_position.distance_to(global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_player = p

	return closest_player

func _physics_process(_delta):
	var target = get_closest_alive_player()
	if target == null:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction = global_position.direction_to(target.global_position)
	velocity = direction * movement_speed
	move_and_slide()

	# Flip do sprite
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false

	# Animação de andar
	if direction != Vector2.ZERO:
		if walkTimer.is_stopped():
			sprite.frame = (sprite.frame + 1) % sprite.hframes
			walkTimer.start()

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if "take_damage" in body and "is_dead" in body and not body.is_dead:
			body.take_damage(1)
			die() 
	if body.is_in_group("Sword"):
		print("Player")
		die()
