extends Node

var dead_players = 0

func player_died():
	dead_players += 1
	print("MORREUUUUUUUUUUUUUUUUUUUUUUUUUU")
	if dead_players >= 2:
		dead_players = 0
		Global.level = 1
		Global.xp = 0
		get_tree().change_scene_to_file("res://Nodes/GameOver.tscn")
