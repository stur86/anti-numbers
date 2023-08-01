extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	ScoreKeeper.new_score.connect(Callable(self, "update_score"))
	
func update_score(s: int):
	text = "Score: " + str(s)
