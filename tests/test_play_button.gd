extends Node

func _ready():
	var game_over = preload("res://codigos/game_over.gd").new()
	game_over._on_play_pressed()

	# Como não tem como verificar a mudança de cena facilmente, aqui é mais teórico
	print("✅ Botão Play executado (verificar mudança de cena manualmente).")
	#get_tree().quit()
