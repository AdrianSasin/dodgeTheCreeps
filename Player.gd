extends Area2D

signal hit

@export var speed: float = 400.0 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

var shield = false

func _ready():
	screen_size = get_viewport_rect().size
	hide()


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed(&"move_right"):
		velocity.x += 1
	if Input.is_action_pressed(&"move_left"):
		velocity.x -= 1
	if Input.is_action_pressed(&"move_down"):
		velocity.y += 1
	if Input.is_action_pressed(&"move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = &"right"
		$AnimatedSprite2D.flip_v = false
		$Trail.rotation = 0
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = &"up"
		rotation = PI if velocity.y > 0 else 0.0
	if Input.is_key_pressed(KEY_SPACE):
		shield = true
		$AnimatedSprite2D.modulate = Color(0, 1, 1)
	else:
		shield = false
		$AnimatedSprite2D.modulate = Color.WHITE


func start(pos):
	position = pos
	rotation = 0
	show()
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(_body):
	if(!shield):
		hide() # Player disappears after being hit.
		hit.emit()
		$CollisionShape2D.set_deferred(&"disabled", true) # Must be deferred as we can't change physics properties on a physics callback.

	
	
