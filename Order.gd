extends Node2D

signal order_processed

var fruitInSmoothie
var fruitOrdered = []

func _ready():
	set_order()
	
#	$AnimatedSprite/Fruit1.get_node("AnimatedSprite").play("strawberry")
#	$AnimatedSprite/Fruit2.get_node("AnimatedSprite").play("blueberry")


func set_order():
	fruitOrdered.resize(2)
	fruitOrdered[0] = $AnimatedSprite/Fruit1.get_name()
	fruitOrdered[1] = $AnimatedSprite/Fruit2.get_name()
	fruitOrdered.sort()

func expect_some_fruit(fruit):
	fruitInSmoothie = fruit

func retreat():
	$AnimationPlayer.play("Order_Complete_Anim")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("order_processed")
	queue_free()

func fail_order():
	print("fail")
	$FailAudio.play()
	$AnimationPlayer.play("Order_Failed_Anim")
	
func succeed_order():
	$SuccessAudio.play()
	retreat()

func _process_order():
	var failed = false
	if (fruitInSmoothie != null):
		if (fruitOrdered.size() != fruitInSmoothie.size()):
			print("failed due to size difference")
			failed = true
		else:
			for i in range(fruitOrdered.size()):
				if (fruitOrdered[i] != fruitInSmoothie[i]):
					print("wrong fruit")
					print(fruitOrdered[i])
					print(fruitInSmoothie[i])
					failed = true
	else:
		print("failed due to fruit in smoothie was null")
		failed = true
	if (failed == true):
		fail_order()
	else:
		succeed_order()