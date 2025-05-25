extends Area2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var colisor = $CollisionShape2D

var has_hit = false

func _ready():
	anim_sprite.play()
	anim_sprite.animation_finished.connect(_on_animation_finished)
	colisor.disabled = false

func _on_animation_finished() -> void:
	queue_free()
 
func _on_body_entered(body: Node2D) -> void:
	if has_hit:
		return
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage()
		body.take_damage(1, global_position)
		has_hit = true
