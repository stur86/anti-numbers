extends Area2D

@export var elastic_k = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	
func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	
	for b in bodies:
		# Apply a central force
		var r = b.global_position-global_position
		b.apply_force(-elastic_k*r)


func _on_body_exited(body):
	if body.active:
		# It left, wasn't just destroyed
		body.vanish()
		ScoreKeeper.lose_life()
