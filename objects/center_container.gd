extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	ScoreKeeper.game_over.connect(Callable(self, "show"))
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed("Restart"):
		get_tree().paused = false
		get_tree().reload_current_scene()
	elif event.is_action_pressed("Escape"):
		# Quit game
		get_tree().quit()
