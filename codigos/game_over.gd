extends Node2D

@onready var record_label = $Record  # <- Ajuste o caminho se estiver diferente
@onready var record_label2 = $Record2  # <- Ajuste o caminho se estiver diferente

func _ready():
	$VBoxContainer/Play.grab_focus()
	record_label.text = "Player 1 sobreviveu: \n%.1f segundos" % Global.survival_time
	record_label2.text = "Player 2 sobreviveu: \n%.1f segundos" % Global.survival_time2

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Nodes/Rouguelike muito foda.tscn")
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()
	pass

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Nodes/Menu.tscn")
	pass
