extends Area2D

export (int) var DAMAGE_GIVEN = 25
export (int) var SPEED = 50
export (int) var HEALTH = 5

var fruitScene = preload("res://Fruit.tscn")

var attack = false;
var velocity = Vector2()
var parent

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
	var fruit = $Fruit
	var main = get_tree().get_root().get_node("Main")
	var pos = fruit.get_global_transform()

	self.remove_child(fruit)
	main.add_child(fruit)
	fruit.set_owner(main)
	
	fruit.mode = RigidBody2D.MODE_RIGID
	fruit.global_transform = pos

func destroy_enemy():
	drop_fruit()
	parent.queue_free()
#	hide()
#	queue_free()