extends BasePlayer

@onready var hud_p2 = get_parent().get_node("HUD_Player2")
var mouse_node

func _ready():
	input_prefix = "p2_"
	hud_p2.update_health(current_health)
	connect("health_changed", Callable(hud_p2, "_on_player_health_changed"))

	#mouse_node = get_tree().get_root().get_node("world/mouse")

	super._ready()
