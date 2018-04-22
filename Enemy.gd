extends Area2D

export (int) var DAMAGE_GIVEN = 25
export (int) var SPEED = 50
export (int) var HEALTH = 5

signal enemy_died

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
	$AnimatedSprite.animation = "explosion"
	yield($AnimatedSprite, "animation_finished" )
	parent.queue_free()
