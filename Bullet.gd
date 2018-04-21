extends Area2D

export (int) var SPEED

func _ready():
	randomize()
	var randomColor = randf();
	$ColorRect.color = Color(randomColor, randomColor, randomColor);

func _process(delta):
	var velocity = Vector2()
	velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		
	position += velocity * delta

func _on_screen_exited():
	queue_free()
