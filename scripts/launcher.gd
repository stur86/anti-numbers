extends Node2D

@export var rot_speed = 1.0
@export var fire_speed = 300.0
@export var reload_time = 1.0

const Particle = preload("res://objects/number_particle.tscn")

const SP_INTERP = 0.3
var target_speed = 0.0
var actual_speed = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

func rotate_launcher(angle: float):
	rotate(angle)
	$Platform/Loader.rotate(-angle)
	
func launch_particle():
	var p = $Platform/Loader.get_child(0)
	if p == null:
		return
	# Remove from parent
	var start_pos = p.global_position
	$Platform/Loader.remove_child(p)
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
	# Set particle charge
	var q = randi_range(1, new_p.max_charge)
	q *= sign(randf()-0.5)
	new_p.charge = q
	$Platform/Loader.add_child(new_p)
	new_p.position = Vector2.ZERO

func _process(delta):
	
	if Input.is_action_pressed("Right"):
		target_speed = -rot_speed
	elif Input.is_action_pressed("Left"):
		target_speed = rot_speed
	else:
		target_speed = 0.0
	actual_speed = lerp(actual_speed, target_speed, SP_INTERP)
	rotate_launcher(actual_speed*delta)
	
	if Input.is_action_just_pressed("Launch"):
		launch_particle()
