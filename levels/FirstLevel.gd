extends Node2D

var gameOver = false

func _ready():
	randomize()

func game_over():
	$CanvasLayer2/GameOver.visible = true
	gameOver = true
	
func pause():
	if not gameOver:
		$CanvasLayer/StartPause.visible = true
		get_tree().paused = true
	
func unpause():
	if not gameOver:
		$CanvasLayer/StartPause.visible = false
		get_tree().paused = false

func restart():
	get_tree().change_scene("res://levels/FirstLevel.tscn")
	get_tree().paused = false
