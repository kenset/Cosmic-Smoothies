extends CanvasLayer

signal restart_game

func _ready():
	reset()

func game_over():
	$GameOver.show()

func reset():
	$GameOver.hide()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_RestartButton_pressed():
	emit_signal("restart_game")
