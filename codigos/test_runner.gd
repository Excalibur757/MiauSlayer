extends Node

func _ready():
	print("✅ Iniciando testes...")

	run_all_tests()
	print("✅ Todos os testes foram executados.")
	get_tree().change_scene_to_file("res://Nodes/Menu.tscn")

func run_all_tests():
	await get_tree().create_timer(1).timeout
	run_test("res://tests/test_hud.gd")
	run_test("res://tests/test_gameover.gd")
	run_test("res://tests/test_play_button.gd")

func run_test(script_path: String):
	var test_instance = load(script_path).new()
	add_child(test_instance)
	test_instance._ready()
