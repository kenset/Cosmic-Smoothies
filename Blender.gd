extends Node2D

var fruitScene = preload("res://Fruit.tscn")
var invalid_button_press = preload("res://Sounds/invalid_button_press.wav")

var fruitContained = []

signal is_blending
signal blending_finished

func _ready():
	$AnimatedSprite.play("open")
	$Smoothie.hide()
	$Smoothie.get_node("AnimatedSprite").scale *= 2

func blend():
	$AnimatedSprite.play("closing")
	$ButtonArea/ButtonCollider.disabled = true
	yield($AnimatedSprite, "animation_finished")
	get_tree().call_group("orders", "expect_some_fruit", get_fruits_to_blend())
	get_tree().call_group("fruit_to_blend", "blend_yourself")
	emit_signal("is_blending")
	$AnimatedSprite.play("blending")
	$BlendingTimer.start()

func reset_blender():
	$AnimatedSprite.play("open")

func throw_smoothie():
	var smoothieInstance = fruitScene.instance()
	smoothieInstance.isSmoothie = true

	var main = get_tree().get_root().get_node("Main")
	var pos = $Smoothie.get_global_transform()

	main.add_child(smoothieInstance)
	smoothieInstance.set_owner(main)

	smoothieInstance.mode = RigidBody2D.MODE_CHARACTER
	smoothieInstance.global_transform = pos
	smoothieInstance.get_node("AnimatedSprite").scale *= 2
	smoothieInstance.apply_impulse(Vector2(0, 0), Vector2(-20, -60))

func _on_ButtonArea_area_entered(area):
	if (area.is_in_group("bullets")):
		area.queue_free()
		$AnimatedSprite.play("open_button_in")
		if (!$Audio.playing && $ButtonPressTimer.is_stopped()):
			$Audio.stream = invalid_button_press
			$Audio.play()
		var fruit = get_tree().get_nodes_in_group("fruit_to_blend")
		if (fruit.size() != 0):
			blend()
		else:
			$ButtonPressTimer.start()

func _on_BlendingTimer_timeout():
	emit_signal("blending_finished")
	$AnimatedSprite.play("full")
	$FullBlenderTimer.start()

func _on_FullBlenderTimer_timeout():
	$AnimatedSprite.play("draining")
	yield($AnimatedSprite, "animation_finished")
	
	$AnimatedSprite.play("opening")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("open")
	$ButtonArea/ButtonCollider.disabled = false
	
	$Smoothie.show()
	$Smoothie/AnimationPlayer.play("Move_Smoothie_Anim")
	yield($Smoothie/AnimationPlayer, "animation_finished")
	
	throw_smoothie()
	$Smoothie/AnimationPlayer.play("Reset_Smoothie")

func _on_fruit_received(body):
	if (body.is_in_group("fruit")):
		var fruit = body
		fruit.add_to_group("fruit_to_blend")

func _on_ButtonPressTimer_timeout():
	$AnimatedSprite.play("open")

func get_fruits_to_blend():
	var fruits = get_tree().get_nodes_in_group("fruit_to_blend")
	var fruitNames = []
	fruitNames.resize(fruits.size())
	for i in range(fruits.size()):
		fruitNames[i] = fruits[i].get_name()
	fruitNames.sort()
	return fruitNames
#	print(fruitNames)
