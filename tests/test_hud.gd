extends Node

func _ready():
	var hud = preload("res://codigos/hud.gd").new()
	hud.update_health(50)
	assert(hud.health_label.text == "Vida: 50", "HUD não atualizou corretamente!")
	
	hud.update_level(3)
	assert(hud.level_label.text == "Level: 3", "Level não atualizou corretamente!")

	print("✅ Teste da HUD passou.")
	#get_tree().quit()
