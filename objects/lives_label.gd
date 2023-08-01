extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	ScoreKeeper.new_lives.connect(Callable(self, "update_lives"))

func update_lives(l: int):
	text = "Lives: " + str(l)
