extends BaseChar


# Declare member variables here. Examples:
var velocity = Vector2(0,0)
var speed = 90
var gravity = 20
var jumpforce = -350

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		velocity.x = speed
		$Sprite.play("walk")
		$Sprite.flip_h = true
	elif Input.is_action_pressed("left"):
		velocity.x = -speed
		$Sprite.play("walk")
		$Sprite.flip_h = false
	else:
		$Sprite.play("idle")
		
	velocity.y = velocity.y + gravity
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpforce
	
	velocity =  move_and_slide(velocity,Vector2.UP)
	
	velocity.x = lerp(velocity.x,0,0.2)
	



func _on_fallzone_body_entered(body):
	get_tree().change_scene("res://Level1.tscn")

func bounce():
	velocity.y = jumpforce*0.5
	
func ingressAttack( enemy_pos, ingressDmg ):
	
	velocity.y = jumpforce * 0.4
	
	if position.x < enemy_pos.x:
		velocity.x = -jumpforce * 0.6
	elif position.x > enemy_pos.x:
		velocity.x = -jumpforce * 0.6
	
	# Taking over control of the charecter 
	Input.action_release("left")
	Input.action_release("right")
	#for dmg in ingressDmg.dmgs.values():
	#	# In the future we can add resistance to certain types of damage but for now subtract all damage types from HP
	#	hp -= dmg
	hp -= ingressDmg.amount
	print("Recieved dmgAmnt: %f of dmgType %d REMAINING HP:%f" % [ingressDmg.amount, ingressDmg.type, hp])
	$Timer.start()


func _on_Timer_timeout():
	if hp > 0:
		set_modulate(Color(1,1,1,1))
	else:
		get_tree().change_scene("res://Level1.tscn")

