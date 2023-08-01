extends Node2D

@export var rot_speed = 1.0
@export var fire_speed = 300.0
@export var reload_time = 1.0

const Particle = preload("res://objects/number_particle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

func rotate_launcher(x: float):
	get_parent().rotate(x)
	$Loader.rotate(-x)
	
func launch_particle():
	var p = $Loader.get_child(0)
	if p == null:
		return
	# Remove from parent
	var start_pos = p.global_position
	$Loader.remove_child(p)
	var pparent = get_tree().get_first_node_in_group("ParticleParent")
	pparent.add_child(p)
	p.global_position = start_pos
	p.global_rotation = 0
	# Fire direction?
	var v = fire_speed*global_transform.basis_xform(Vector2.UP)
	p.launch(v)
	
	$ReloadTimer.start(reload_time)

func reload_launcher():
	# Create a new one
	var new_p = Particle.instantiate()
	$Loader.add_child(new_p)
	new_p.position = Vector2.ZERO

func _process(delta):
	
	if Input.is_action_pressed("Right"):
		rotate_launcher(-rot_speed*delta)
	elif Input.is_action_pressed("Left"):
		rotate_launcher(rot_speed*delta)
	
	if Input.is_action_just_pressed("Launch"):
		launch_particle()
