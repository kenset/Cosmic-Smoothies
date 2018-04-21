extends Path2D

signal path_completed

export (float) var SPEED = 0.5

var completedPath = false;

export (float) var STARTING_OFFSET = 0.0

func _ready():
	randomize()
	$PathFollow2D.set_unit_offset(STARTING_OFFSET)

func _process(delta):
	$PathFollow2D.set_unit_offset($PathFollow2D.get_unit_offset() + ((SPEED + delta) / 100.0))
	
	if ($PathFollow2D.get_unit_offset() > 1.0 && completedPath == false):
		completedPath = true;
		$attackTimer.start()

func _on_attackTimer_timeout():
	emit_signal("path_completed")
