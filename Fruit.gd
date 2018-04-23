extends RigidBody2D

export (bool) var isSmoothie = false

var splat_01 = preload("res://Sounds/splats/splat_01.wav")
var splat_02 = preload("res://Sounds/splats/splat_02.wav")

var fruitTypes = ["strawberry", "apple", "banana", "blueberry"]
var splatTypes = ["strawberry_splat", "apple_splat", "banana_splat", "blueberry_splat"]

var splatSounds = [splat_01, splat_02]
var fruitIndex

func _ready():
	randomize()
	if (isSmoothie):
		$AnimatedSprite.animation = "smoothie"
	else:
		fruitIndex = randi() % fruitTypes.size()
		$AnimatedSprite.animation = fruitTypes[fruitIndex]

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func splat():
	$AnimatedSprite.position.y = -30
	if isSmoothie:
		$AnimatedSprite.animation = "strawberry_splat"
	else:
		$AnimatedSprite.scale *= 2
		$AnimatedSprite.animation = splatTypes[fruitIndex]
	$SplatSounds.stream = splatSounds[randi() % 2]
	$SplatSounds.play()
	self.set_collision_mask_bit(0, false)