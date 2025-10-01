extends RigidBody2D

func _ready():
	$AnimatedSprite2D.play()
	##var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = "walk"

signal defeated

func _on_VisibilityNotifier2D_screen_exited():
	defeated.emit()
	queue_free()
