extends Control

func _ready():
	$MarginContainer/Center/VBoxContainer/HBoxContainer/VBoxContainer/BackContainer/Back.connect("pressed", self, "_back_button_pressed")
	$MarginContainer/Center/VBoxContainer/HBoxContainer/VBoxContainer/Restart/Restart.connect("pressed", self, "_restart_button_pressed")
	visible = false

func _back_button_pressed():
	get_tree().get_root().get_node("Game").victory_back()


func _restart_button_pressed():
	get_tree().get_root().get_node("Game").restart()




func _input(event):
	if not visible:
		return
	if event.is_action_pressed("ui_back"):
		get_tree().get_root().get_node("Game").restart()
	if event.is_action_pressed("ui_cancel"):
		get_tree().get_root().get_node("Game").victory_back()
