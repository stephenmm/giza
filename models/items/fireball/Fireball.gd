extends Area2D

const SPEED = 600
var velocity = Vector2()
var direction = 1

func _ready():
	print("Fireball is _ready")
	pass 
	
func set_firball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("shoot")
	



func _on_VisibilityNotifier2D_screen_exited():
	print("Fireball left the screen")
	queue_free()


func _on_Fireball_body_entered(body):
	print("bang")
	if body.has_method("ingressAttack"):
		body.ingressAttack( Damage.new(5) )
	queue_free()
