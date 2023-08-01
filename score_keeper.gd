extends Node

var score: int = 0
var lives: int = 3

signal new_score
signal new_lives
signal game_over

# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0
	
func reset():
	score = 0
	
func add_score(s: int):
	score += s
	new_score.emit(score)

func lose_life():
	lives -= 1
	new_lives.emit(lives)
	if lives <= 0:
		# Freeze the tree
		get_tree().paused = true
		game_over.emit()
