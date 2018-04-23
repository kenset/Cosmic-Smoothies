extends Node

func _ready():
	$BackgroundMusic.play()
	set_process_input(true)
	$MainMenu/Control.show()
	$HowToPlay/Control.hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_StartGame_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_HowToPlay_pressed():
	$MainMenu/Control.hide()
	$HowToPlay/Control.show()

func _on_Back_pressed():
	$HowToPlay/Control.hide()
	$MainMenu/Control.show()
