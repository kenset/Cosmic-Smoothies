extends Node

func _ready():
	$BackgroundMusic.play()
	set_process_input(true)
	$MainMenu/Control.show()
	$HowToPlay/Control.hide()
	$Credits/Control.hide()
	
	if OS.get_name()=="HTML5":
		OS.set_window_maximized(true)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		quit()

func quit():
	get_tree().quit()

func _on_StartGame_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_HowToPlay_pressed():
	$MainMenu/Control.hide()
	$HowToPlay/Control.show()

func _on_Back_pressed():
	$HowToPlay/Control.hide()
	$Credits/Control.hide()
	$MainMenu/Control.show()


func _on_Credits_pressed():
	$MainMenu/Control.hide()
	$Credits/Control.show()

func _on_Quit_pressed():
	quit()
