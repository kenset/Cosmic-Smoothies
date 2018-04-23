extends Area2D

export (int) var DAMAGE_GIVEN = 25
export (int) var SPEED = 50
export (int) var HEALTH = 5

signal enemy_died

var explosion_00 = preload("res://Sounds/explosions/Explosion_00.wav")
var explosion_01 = preload("res://Sounds/explosions/Explosion_01.wav")
var explosion_02 = preload("res://Sounds/explosions/Explosion_02.wav")
var explosion_03 = preload("res://Sounds/explosions/Explosion_03.wav")

var explosionSounds = [explosion_00, explosion_01, explosion_02, explosion_03]

var attack = false;
var velocity = Vector2()
var parent
var holdingFruit = true

func _ready():
	parent = self.get_parent().get_parent()
	if (parent.scale.x == -1):
		$Fruit.scale.x *= -1
	
	randomize()
	
func _process(delta):
	if (attack == true):
		attack(delta)

func attack(delta):
	position += velocity * delta

func _path_completed():
	velocity.x += randf() * 4 - 2
	velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		
	attack = true;

func _on_Enemy_area_entered(area):
	if (area.is_in_group("bullets")):
		area.queue_free()
		HEALTH -= 1
		if (HEALTH <= 0):
			destroy_enemy()

func drop_fruit():
	if (holdingFruit):
		var fruit = $Fruit
		var main = get_tree().get_root().get_node("Main")
		var pos = fruit.get_global_transform()
	
		self.remove_child(fruit)
		main.add_child(fruit)
		fruit.set_owner(main)
		
		fruit.mode = RigidBody2D.MODE_CHARACTER
		fruit.global_transform = pos
		holdingFruit = false

func destroy_enemy():
	drop_fruit()
	parent.SPEED = 0.0
	emit_signal("enemy_died")
	play_explosion()
	$AnimatedSprite.animation = "explosion"
	yield($AnimatedSprite, "animation_finished" )
	parent.queue_free()
	
func play_explosion():
	$ExplosionSound.stream = explosionSounds[randi() % 4]
	$ExplosionSound.play()
