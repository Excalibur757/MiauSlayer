extends CharacterBody2D

@export var max_health: int = 3
@export var speed: float = 30
@export var knockback_strength: float = 1200.0

var xp = preload("res://Nodes/xp.tscn")
var current_health: int
var is_dying: bool = false

func _ready():
	current_health = max_health
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play("walk")

	# Escalar a dificuldade baseada no nível atual
	scale_difficulty(Global.level)


func _physics_process(delta):
	if is_dying:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var players = get_tree().get_nodes_in_group("player")

	if players.is_empty():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var closest_player = null
	var min_dist = INF

	for p in players:
		if !is_instance_valid(p):
			continue
		if p.is_dead:
			continue

		var dist = global_position.distance_squared_to(p.global_position)
		if dist < min_dist:
			min_dist = dist
			closest_player = p

	if closest_player == null:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction = (closest_player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	# Lógica de animação de andar
	if $AnimatedSprite2D and !is_dying:
		if direction.x >= 0:
			if $AnimatedSprite2D.animation != "walk":
				$AnimatedSprite2D.play("walk")
		else:
			if $AnimatedSprite2D.animation != "walk_1":
				$AnimatedSprite2D.play("walk_1")

func take_damage(amount: int = 3, from_position: Vector2 = Vector2.ZERO):
	if is_dying:
		return

	current_health -= amount
	if $hit:
		$hit.visible = true  # Garante que apareça
		$hit.play("damage")
	if current_health <= 0:
		die()
	else:
		if from_position != Vector2.ZERO:
			var knockback_dir = (global_position - from_position).normalized()
			velocity = knockback_dir * knockback_strength
		move_and_slide()

func die():
	#print("[MORTE] Inimigo morrendo...")
	is_dying = true
	velocity = Vector2.ZERO
	var new_xp = xp.instantiate()
	new_xp.global_position = self.global_position
	get_tree().current_scene.add_child(new_xp)
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play("death")
		$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_death_animation_finished"))
	#else:
		#print("[MORTE] AnimatedSprite2D NÃO encontrado ao morrer")

func scale_difficulty(player_level: int):
	max_health = int(3 + (player_level - 1) * 1.5)  # vida base + crescimento
	current_health = max_health
	speed += (player_level - 1) * 2  # só se quiser deixar mais rápidos também

func _on_death_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		#print("[MORTE] Animação de morte terminou, removendo inimigo")
		queue_free()

func _on_damage_area_body_entered(body: Node2D) -> void:
	#print("[COLISÃO] Entrou em área de dano")
	if is_dying:
		#print("[COLISÃO] Mas está morrendo, ignorando")
		return
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(1)

		#else:
			#print("[COLISÃO] Jogador NÃO tem método take_damage")
	#else:
		#print("[COLISÃO] Colidiu com algo que não é jogador:", body.name)
