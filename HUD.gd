extends CanvasLayer

signal restart_game

func _ready():
	set_process_input(true)
	reset()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("ui_pause"):
		toggle_pause()

func toggle_pause():
	if (!$GameOver.visible):
		get_tree().paused = !get_tree().paused
		if (get_tree().paused):
			$Paused.show()
		else:
			$Paused.hide()

func game_over():
	$GameOver.show()

func reset():
	$GameOver.hide()
	$Paused.hide()

func _on_RestartButton_pressed():
	toggle_pause()
	emit_signal("restart_game")

func _on_ResumeButton_pressed():
	toggle_pause()
