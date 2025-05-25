extends Control


@onready var audio_player = $AudioStreamPlayer2D
@onready var music_label = $PanelContainer/VBoxContainer/Label
@onready var cd_node = $PanelContainer/VBoxContainer/Node2D/TextureRect

var music_list = []
var current_music_index = 0

func _ready():
	load_music_from_folder("res://Audio/Music_gameover/")
	if music_list.size() > 0:
		play_music(current_music_index)
		audio_player.finished.connect(_on_music_finished)
	else:
		print("Nenhuma música encontrada na pasta.")

func load_music_from_folder(path: String):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				if file_name.to_lower().ends_with(".mp3") or file_name.to_lower().ends_with(".ogg") or file_name.to_lower().ends_with(".wav"):
					var full_path = path + file_name
					var stream = load(full_path)
					music_list.append({"name": file_name.get_basename(), "stream": stream})
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Erro ao abrir pasta: ", path)

func play_music(index: int):
	var music = music_list[index]
	audio_player.stream = music["stream"]
	audio_player.play()
	music_label.text = music["name"]

func _on_music_finished():
	current_music_index = (current_music_index + 1) % music_list.size()
	play_music(current_music_index)

func _process(delta):
	if audio_player.playing:
		cd_node.rotation += deg_to_rad(90) * delta  # CD gira enquanto toca
