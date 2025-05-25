extends Node2D

@export var slime_scene: PackedScene
@export var skelleton_scene: PackedScene
@export var default_enemy_scene: PackedScene  # já existente no projeto

@export var spawn_interval: float = 1.0
@export var spawn_radius: float = 400.0

@onready var timer = $Timer
@onready var spawn_center = get_tree().get_first_node_in_group("SpawnCenter")

func _ready():
	timer.wait_time = spawn_interval
	timer.timeout.connect(spawn_enemy)
	timer.start()

func spawn_enemy():
	if spawn_center == null:
		print("SpawnCenter (Marker2D) não encontrado!")
		return

	var enemies = [default_enemy_scene, slime_scene, skelleton_scene]
	var chosen_enemy_scene = enemies.pick_random()

	if chosen_enemy_scene == null:
		print("Uma das cenas de inimigo está faltando!")
		return

	var angle = randf() * TAU
	var distance = randf_range(100.0, spawn_radius)
	var offset = Vector2(cos(angle), sin(angle)) * distance

	var spawn_position = spawn_center.global_position + offset

	var enemy = chosen_enemy_scene.instantiate()
	enemy.global_position = spawn_position
	get_parent().add_child(enemy)
	
