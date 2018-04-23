extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$AnimatedSprite.play("open")
	$Smoothie.hide()
	$Smoothie.get_node("AnimatedSprite").scale *= 2

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func blend():
	$AnimatedSprite.play("closing")
	$ButtonArea/ButtonCollider.disabled = true
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("blending")
	$BlendingTimer.start()

func reset_blender():
	$AnimatedSprite.play("open")

func throw_smoothie():
	var smoothie = $Smoothie

	var main = get_tree().get_root().get_node("Main")
	var pos = smoothie.get_global_transform()

	self.remove_child(smoothie)
	main.add_child(smoothie)
	smoothie.set_owner(main)

	smoothie.mode = RigidBody2D.MODE_CHARACTER
	smoothie.global_transform = pos
	smoothie.apply_impulse(Vector2(0, 0), Vector2(-20, -60))

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
	$ButtonArea/ButtonCollider.disabled = false
	
	$Smoothie.show()
	$Smoothie/AnimationPlayer.play("Move_Smoothie_Anim")
	yield($Smoothie/AnimationPlayer, "animation_finished")
	
	throw_smoothie()
