extends RigidBody2D

@export var charge: int = 1
@export var max_charge: int = 7

const F0 = 1e6

func _ready():
	# Set the text to own charge
	var label_sign = "+" if charge > 0 else ""
	$ParticleSprite/ChargeLabel.text = label_sign + str(charge)
	
	# Base the color off the charge
	var h = (charge+max_charge)/(2.2*max_charge)
	var c = Color.from_hsv(h, 0.9, 0.8)
	$ParticleSprite.modulate = c
	
	set_physics_process(true)
	
func launch(v: Vector2):
	freeze = false
	apply_impulse(v)

func _physics_process(_delta):
	
	if freeze:
		# Do nothing
		return
	
	var particles = get_tree().get_nodes_in_group("Particles")	
	for p in particles:
		if self == p or p.freeze:
			continue
		
		# Distance?
		var v = (p.global_position - self.global_position)
		var r2 = v.length_squared()
		var n = v.normalized()
		
		var F = -F0*charge*p.charge*n/r2
		apply_central_force(F)


func _on_body_entered(body):
	
	var other_charge = body.get("charge")
	if other_charge == -charge:
		# Annihilation!
		body.queue_free()
		queue_free()
		ScoreKeeper.add_score(50)


func _on_visible_on_screen_notifier_2d_screen_exited():
	# Destroy and lose one life
	ScoreKeeper.lose_life()
	queue_free()
