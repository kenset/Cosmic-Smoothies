extends Area2D

signal shooting
signal stop_shooting

export (int) var SPEED = 400;
var screensize
var bulletScene = preload("res://Bullet.tscn")

var isCatching = false
var isBlending = false
var isHoldingFruit = false
var startingPos

func _ready():
	screensize = get_viewport_rect().size
	set_process_input(true)
	startingPos = position

func _input(event):
	if event.is_action_pressed("ui_toggle_catch"):
		if (isCatching):
			if (isHoldingFruit):
				dropFruit()
			startShooting()
		else:
			startCatching()
	if (event.is_action_pressed("ui_blend_aim")):
		if (isCatching):
			if (isHoldingFruit):
				dropFruit()
		startBlending()
		flip_right()
	elif (event.is_action_released("ui_blend_aim")):
		startShooting()

func _process(delta):
	move(delta)
	take_action()

func dropFruit():
	if ($Fruit != null):
		var fruit = $Fruit
		
		var main = get_tree().get_root().get_node("Main")
		var pos = fruit.get_global_transform()

		self.remove_child(fruit)
		main.add_child(fruit)
		fruit.set_owner(main)

		fruit.mode = RigidBody2D.MODE_CHARACTER
		fruit.global_transform = pos
		isHoldingFruit = false
		
		return fruit

func startShooting():
	isCatching = false
	isBlending = false
	$AnimatedSprite.animation = "shooting"
	var x = -22 if $AnimatedSprite.flip_h == true else 22
	$AnimatedSprite/Gunpoint.position = Vector2(x, -150)
	$AnimatedSprite/Gunpoint.rotation_degrees = 0
	
func startCatching():
	isCatching = true
	isBlending = false
	$AnimatedSprite.animation = "catching"

func startBlending():
	isCatching = false
	isBlending = true
	$AnimatedSprite.animation = "blending"
	var x
	var rot
	if ($AnimatedSprite.flip_h == true):
		x = -135
		rot = -90
	else:
		x = 135
		rot = 90
	$AnimatedSprite/Gunpoint.position = Vector2(x, 12)
	$AnimatedSprite/Gunpoint.rotation_degrees = rot

func resetPlayer():
	for child in self.get_children():
		if (child.is_in_group("fruit")):
			child.queue_free()
	startShooting()
	position = startingPos

func take_action():
	if (!isCatching):
		if (Input.is_action_pressed("ui_action")):
			emit_signal("shooting")
			var bulletInstance = bulletScene.instance()
			bulletInstance.position = $AnimatedSprite/Gunpoint.global_position
			bulletInstance.rotation = $AnimatedSprite/Gunpoint.global_rotation
			get_tree().get_root().add_child(bulletInstance)
			if (!$GunshotSound.playing):
				$GunshotSound.play()
		elif (Input.is_action_just_released("ui_action")):
			emit_signal("stop_shooting")
	else:
		if (Input.is_action_pressed("ui_action") && isHoldingFruit):
			var fruit = dropFruit()
			if (fruit != null):
				$ThrowSound.play()
				fruit.apply_impulse(Vector2(0, 0), Vector2(30, -60))
				fruit.set_collision_mask_bit(0, true)

func flip_right():
	$AnimatedSprite.flip_h = false
	$AnimatedSprite/Gunpoint.position.x = 22 if isBlending == false else 135
	$AnimatedSprite.playing = true
	$AnimatedSprite/Gunpoint.rotation_degrees = 90 if isBlending else 0
	
func flip_left():
	$AnimatedSprite.flip_h = true
	$AnimatedSprite/Gunpoint.position.x = -22 if isBlending == false else -135
	$AnimatedSprite/Gunpoint.rotation_degrees = -90 if isBlending else 0
	$AnimatedSprite.playing = true
		
func move(delta):
	var velocity = Vector2() 
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		flip_right()
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		flip_left()
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		if ($FootstepsTimer.is_stopped()):
			$FootstepsSound.play()
			$FootstepsTimer.start()
		
	if (velocity.length() == 0):
		$AnimatedSprite.playing = false
		$FootstepsTimer.stop()
	
	position += velocity * delta
	
	position.x = clamp(position.x, -100, 1070)

func _on_CatchArea_body_entered(body):
	if (body.is_in_group("fruit") && isCatching && !isHoldingFruit):
		var fruit = body
		var main = get_tree().get_root().get_node("Main")
		var pos = $AnimatedSprite/CatchArea/CatchAreaCollision.global_position

		if (fruit.get_parent() == main):
			main.remove_child(fruit)
			self.add_child(fruit)
			fruit.set_owner(self)
			fruit.set_name("Fruit")
			isHoldingFruit = true
			
			fruit.mode = RigidBody2D.MODE_STATIC
			fruit.global_position = pos

func _on_FootstepsTimer_timeout():
	$FootstepsSound.play()

func deliver_smoothie():
	if (isHoldingFruit && $Fruit.isSmoothie):
		startShooting()
		isHoldingFruit = false
		$Fruit.queue_free()
