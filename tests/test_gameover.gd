extends Node

func _ready():
	Global.survival_time = 25.0
	Global.survival_time2 = 30.0

	var game_over = preload("res://codigos/game_over.gd").new()
	game_over._ready()

	assert(game_over.record_label.text.find("25.0") != -1 or game_over.record_label.text.find("30.0") != -1, "Record não exibido corretamente!")

	print("✅ Teste de Game Over passou.")
	#get_tree().quit()
