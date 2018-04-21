extends Area2D

signal shooting
signal stop_shooting

export (int) var SPEED = 400;
var screensize
var bulletScene = preload("res://Bullet.tscn")

func _ready():
	screensize = get_viewport_rect().size

func _process(delta):
	move(delta)
	shoot()

func shoot():
	if (Input.is_action_pressed("ui_shoot")):
		emit_signal("shooting")
		var bulletInstance = bulletScene.instance()
		bulletInstance.position = position
		get_tree().get_root().add_child(bulletInstance)
	else:
		emit_signal("stop_shooting")

func move(delta):
	var velocity = Vector2() 
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		
	position += velocity * delta
	
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, screensize.y * 0.75, screensize.y)

func _on_EnemyPath_path_completed():
	pass # replace with function body
