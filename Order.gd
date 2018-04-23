extends Node2D

var fruitToExpect

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	pass
#	print(fruitToExpect)

func expect_some_fruit(fruit):
	fruitToExpect = fruit