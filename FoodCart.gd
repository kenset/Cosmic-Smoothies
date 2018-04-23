extends Node2D

func _ready():
	$Smoothie.hide()

func _on_Area2D_area_entered(area):
	if (area.is_in_group("Player") && area.isHoldingFruit && area.get_node("Fruit").isSmoothie):
		area.deliver_smoothie()
		$Smoothie.show()
		$Smoothie/AnimationPlayer.play("Deliver_Smoothie_Anim")
		$SmoothieDeliveredSound.play()
