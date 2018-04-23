extends Node2D

enum Stars {FULL = 0, MODERATE, LIGHT}
export(Stars) var STARRINESS

func _ready():
	set_starriness()

func set_starriness():
	if STARRINESS == FULL:
		$AnimatedSprite.animation = "full"
	if STARRINESS == MODERATE:
		$AnimatedSprite.animation = "moderate"
	if STARRINESS == LIGHT:
		$AnimatedSprite.animation = "light"
