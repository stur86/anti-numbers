extends RigidBody2D

@export var charge: int = 1
@export var max_charge: int = 7

const F0 = 1e6
var active = false

func _ready():
	
	freeze = true
	
	# Set the text to own charge
	var label_sign = "+" if charge > 0 else ""
	$ParticleMask/ParticleSprite/ChargeLabel.text = label_sign + str(charge)
	
	# Base the color off the charge
	var h = (charge+max_charge)/(2.2*max_charge)
	var c = Color.from_hsv(h, 0.9, 0.8)
	$ParticleMask/ParticleSprite.modulate = c
	
	set_physics_process(true)
	
func launch(v: Vector2):
	active = true
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
		if not (body.active and active):
			return
		# Annihilation!
		body.explode()
		explode()
		ScoreKeeper.add_score(ScoreKeeper.PAIR_SCORE)

func explode():
	active = false
	set_deferred("freeze", true)
	$Explosion.modulate = $ParticleMask/ParticleSprite.modulate
	$Explosion/Burst.process_mode = Node.PROCESS_MODE_INHERIT
	$AnimationPlayer.play("Explode")

func vanish():
	active = false
	set_deferred("freeze", true)
	$AnimationPlayer.play("Vanish")

func _on_visible_on_screen_notifier_2d_screen_exited():
	# Destroy and lose one life
	ScoreKeeper.lose_life()
	vanish()
