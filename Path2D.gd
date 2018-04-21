extends Path2D

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	$PathFollow2D.set_offset($PathFollow2D.get_offset() + 2 + delta)
