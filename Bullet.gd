extends Area2D

export (int) var SPEED

var shooting_up = true


func _ready():
	randomize()
	var randomColor = randf();
	$ColorRect.color = Color(randomColor, randomColor, randomColor);

func _process(delta):
	var velocity = Vector2()

	if (rotation_degrees >= -1 && rotation_degrees <= 1):
		velocity.y -= 1
	elif (rotation_degrees >= 89 && rotation_degrees <= 91):
		velocity.x += 1
	elif (rotation_degrees <= -89 && rotation_degrees >= -91):
		velocity.x -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		
	position += velocity * delta
	

func _on_screen_exited():
	queue_free()
