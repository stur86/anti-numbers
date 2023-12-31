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
	var r = (body.global_position-global_position).length()
	var max_r = $CollisionShape2D.shape.radius
	if r >= max_r:
		# It left
		body.queue_free()
		ScoreKeeper.lose_life()
