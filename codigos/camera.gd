extends Node2D

#Follow Sistem
@onready var player1 = $"../Player"
@onready var player2 = $"../Player 2"


func _ready():
	pass 

func _process(delta):
	Follow(delta)
	
	pass


func Follow(delta):
	var alive_players = []
	
	if not player1.is_dead:
		alive_players.append(player1)
	if not player2.is_dead:
		alive_players.append(player2)
	
	if alive_players.size() == 0:
		return  # Ninguém vivo, não faz nada

	if alive_players.size() == 1:
		global_position = alive_players[0].global_position
		$Camera2D.zoom = Vector2(1, 1)  # Reset zoom
		return
	
	# Dois jogadores vivos
	var pos1 = alive_players[0].global_position
	var pos2 = alive_players[1].global_position
	var distance = pos1.distance_to(pos2)

	# Zoom dinâmico
	if distance >= 450:
		$Camera2D.zoom += Vector2(0.01 , 0.01)
		if $Camera2D.zoom >= Vector2(0.8 , 0.8):
			$Camera2D.zoom = Vector2(0.8 , 0.8)
	else:
		$Camera2D.zoom -= Vector2(0.01 , 0.01)
		if $Camera2D.zoom <= Vector2(1.0 , 1.0):
			$Camera2D.zoom = Vector2(1.0 , 1.0)

	# Teleporte de emergência
	if distance >= 600:
		alive_players[0].global_position = global_position - Vector2(20 , 0)
		alive_players[1].global_position = global_position + Vector2(20 , 0)

	# Foco da câmera entre os dois vivos
	global_position = (pos1 + pos2) / 2
