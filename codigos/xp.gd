extends Node2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.add_xp(20)
		queue_free()

	pass # Replace with function body.
