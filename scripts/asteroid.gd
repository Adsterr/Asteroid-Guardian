extends RigidBody2D

@onready var animated_sprite = $AnimatedSprite2D

func _on_body_entered(body):
	animated_sprite.play("explode")

func _on_animated_sprite_2d_animation_finished():
	queue_free()
