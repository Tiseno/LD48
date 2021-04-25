extends Control



func _ready():
	$MarginContainer/Center/VBoxContainer/HBoxContainer/VBoxContainer/RestartContainer/Restart.connect("pressed", self, "_restart_button_pressed")
	visible = false


func _restart_button_pressed():
	get_tree().get_root().get_node("Game").restart()

func _input(event):
	if visible and event.is_action_pressed("ui_back") or visible and event.is_action_pressed("ui_cancel"):
		get_tree().get_root().get_node("Game").restart()
