extends RigidBody2D

var fruitTypes = ["strawberry", "apple", "banana"]

func _ready():
	randomize()
	$AnimatedSprite.animation = fruitTypes[randi() % fruitTypes.size()]

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
