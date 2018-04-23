extends Node2D

var fruitScene = preload("res://Fruit.tscn")

func _ready():
	$AnimatedSprite.play("open")
	$Smoothie.hide()
	$Smoothie.get_node("AnimatedSprite").scale *= 2

func blend():
	$AnimatedSprite.play("closing")
	$ButtonArea/ButtonCollider.disabled = true
	yield($AnimatedSprite, "animation_finished")
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
		blend()

func _on_BlendingTimer_timeout():
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
