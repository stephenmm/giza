extends BaseChar
class_name enemy


export var direction = -1
export var detects_cliffs = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floor_checker.enabled = detects_cliffs
	derivedCharSpeedModifier = 0.1

func _physics_process(delta):
	if is_on_wall() or not $floor_checker.is_colliding() and detects_cliffs and is_on_floor():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
		
	velocity.y += 4
	velocity.x = _get_default_speed() * direction
	velocity = move_and_slide(velocity,Vector2.UP)


func _on_top_checker_body_entered(body):
	#if body.has_method("get_class_name"):
	#	if body.get_class_name() == "steve":
	$AnimatedSprite.play("squashed")
	dynamicSpeedModifier = 0.0
	set_collision_layer_bit(4,false)
	set_collision_mask_bit(0,false)
	$top_checker.set_collision_layer_bit(4,false)
	$top_checker.set_collision_mask_bit(0,false)
	$sides_checker.set_collision_layer_bit(4,false)
	$sides_checker.set_collision_mask_bit(0,false)
	$Timer.start()
	#body.bounce()
	


func _on_sides_checker_body_entered(body:BaseChar) -> void:
	#get_tree().change_scene("res://Level1.tscn")
	#var dmgAmnt :float = baseDamage*( Global.rng.randfn(1.0,0.2) );# Multiply base damage by RNG normal dist w/ mean of 1.0 and std dev of 0.2
	var dmgAmnt :float = baseDamage*( 1 );# Error from above line "Invalid get index 'rng' (on base: 'GDScript').", so just set it to 1 for now.
	#var dmgType = Damage.TOXIC;# (dynamic type for now) Not sure how to handle ENUMs w/ static typing in godot so giving up
	var dmgType = 3;# Can't even use enums from other class in previous line... Resorting to magic numbers
	var egressDmg = Damage.new( dmgAmnt, dmgType )
	print("Generating dmgAmnt: %f of dmgType %d" % [egressDmg.amount, egressDmg.type])
	body.ingressAttack( egressDmg )

func _on_Timer_timeout():
	queue_free()
