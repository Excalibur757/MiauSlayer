extends CanvasLayer

@onready var health_label = $LifeLabel
@onready var timer_label = $TimerLabel
@onready var level_label = $LevelLabel

var time_elapsed := 0.0

func _ready():
	update_level(Global.level)


func _process(delta):
	time_elapsed += delta
	timer_label.text = "Tempo: %.1f" % time_elapsed
	
	xp_count()
	

func update_health(value: int):
	#await get_tree().process_frame
	health_label.text = "Vida: %d" % value

func _on_player_health_changed(new_health: Variant) -> void:
	print("HUD atualizada. Nova vida: ", new_health)
	$LifeLabel.text = "Vida: %d" % new_health


func update_level(level: int) -> void:
	level_label.text = "Level: %d" % level


	
func xp_count():
	
	$ProgressBar.value = Global.xp
	if Global.xp >= 100:
		Global.xp = 0
		
	pass

func hide_health():
	$LifeLabel.visible = false


func _on_player_player_died() -> void:
	hide_health()
	Global.survival_time = time_elapsed  # <- Salva o tempo
	print(time_elapsed)
	pass
