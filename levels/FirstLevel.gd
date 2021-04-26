extends Node2D

var gameOver = false
var victory = false

func _ready():
	randomize()

func game_over():
	$CanvasLayer/GameOver.visible = true
	gameOver = true
	$SoundGameOver.play()
	
func pause():
	if not gameOver and not victory:
		$CanvasLayer/StartPause.visible = true
		get_tree().paused = true
	
func unpause():
	if not gameOver and not victory:
		$CanvasLayer/StartPause.visible = false
		get_tree().paused = false

func victory():
	$CanvasLayer/Victory.visible = true
	get_tree().paused = true
	victory = true
	$SoundVictory.play()

func victory_back():
	$CanvasLayer/Victory.visible = false
	victory = false
	get_tree().paused = false

func restart():
	get_tree().change_scene("res://levels/FirstLevel.tscn")
	get_tree().paused = false
