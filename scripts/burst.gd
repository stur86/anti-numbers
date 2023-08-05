extends Area2D

const INTENSITY = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(_delta):
	var particles = get_overlapping_bodies()
	
	for p in particles:
		if p == get_parent().get_parent():
			continue
		if not (p is RigidBody2D):
			continue
		var r = p.global_position-global_position
		p.apply_impulse(r.normalized()*INTENSITY)
		
