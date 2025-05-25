extends CanvasLayer

@onready var health_label = $LifeLabel2 as Label
var time_elapsed2 := 0.0

func _process(delta):
	time_elapsed2 += delta

func update_health(value: int):
	if health_label:
		health_label.text = "Vida P2: %d" % value

func _on_player_health_changed(new_health: Variant) -> void:
	#health_label.text = "Vida P2: %d" % new_health
	$LifeLabel2.text = "Vida: %d" % new_health

func hide_health():
	$LifeLabel2.visible = false


func _on_player_2_player_died() -> void:
	hide_health()
	Global.survival_time2 = time_elapsed2  # <- Salva o tempo
	print(time_elapsed2)
	pass # Replace with function body.
