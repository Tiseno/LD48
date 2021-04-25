extends Control



func _ready():
	$MarginContainer/Center/VBoxContainer/HBoxContainer/VBoxContainer/RestartContainer/Restart.connect("pressed", self, "_restart_button_pressed")
	$MarginContainer/Center/VBoxContainer/HBoxContainer/VBoxContainer/ResumeContainer/Resume.connect("pressed", self, "_resume_button_pressed")
	visible = false

func _resume_button_pressed():
	get_tree().get_root().get_node("Game").unpause()


func _restart_button_pressed():
	get_tree().get_root().get_node("Game").restart()


func _input(event):
	if event.is_action_pressed("ui_back"):
		if get_tree().paused:
			get_tree().get_root().get_node("Game").restart()
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			get_tree().get_root().get_node("Game").unpause()
		else:
			get_tree().get_root().get_node("Game").pause()
