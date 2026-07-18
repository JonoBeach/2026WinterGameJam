extends Area2D
var direction
var origin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.shields.append(get_position())
	$place.play()
	$CollisionShape2D/AnimatedSprite2D.play(direction+origin)
	match direction:
		"left":
			$CollisionShape2D.set_position(Vector2(150,60))
		"right":
			$CollisionShape2D.set_position(Vector2(-30,60))
		"up":
			$CollisionShape2D.set_position(Vector2(60,120))
			$CollisionShape2D/AnimatedSprite2D.z_index = -1
		"down":
			$CollisionShape2D.set_position(Vector2(60,-30))
			$CollisionShape2D/AnimatedSprite2D.z_index = 1
