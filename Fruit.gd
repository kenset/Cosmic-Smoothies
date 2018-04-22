extends RigidBody2D

var fruitTypes = ["strawberry", "apple", "banana", "blueberry"]
var splatTypes = ["strawberry_splat", "apple_splat", "banana_splat", "blueberry_splat"]

var fruitIndex

func _ready():
	randomize()
	fruitIndex = randi() % fruitTypes.size()
	$AnimatedSprite.animation = fruitTypes[fruitIndex]

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func splat():
	$AnimatedSprite.scale *= 2
	$AnimatedSprite.position.y = -30
	$AnimatedSprite.animation = splatTypes[fruitIndex]