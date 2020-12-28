extends BaseChar
class_name steve

const FIREBALL = preload("res://models/items/fireball/Fireball.tscn")
enum SPEED_STATE {IDLE, WALK, RUN}
enum SQUAT_STATE {NONE, TEMP, STKY}
var spdSt
var sqtSt
var TapCountDown = 0
var reloading
var reload_time

# Called when the node enters the scene tree for the first time.
func _ready():
	spdSt=SPEED_STATE.IDLE
	sqtSt=SQUAT_STATE.NONE
	$CxnShp2D_Stand.disabled = false
	$CxnShp2D_Squat.disabled = true
	derivedCharSpeedModifier = 1.0
	reloading = false
	reload_time = 0.5

func get_charecter_type(): 
	return "player"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _get_default_speed() -> float:
	var speed: float = baseCharSpeed * derivedCharSpeedModifier * dynamicSpeedModifier
	if sqtSt != SQUAT_STATE.NONE:
		speed *= 0.5
	return speed

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		_set_states(SPEED_STATE.WALK,-1)
		velocity.x = _get_default_speed()
		$Sprite.flip_h = true
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
	elif Input.is_action_pressed("left"):
		_set_states(SPEED_STATE.WALK,-1)
		velocity.x = -1 * _get_default_speed()
		$Sprite.flip_h = false
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
	if Input.is_action_just_released("right") or Input.is_action_just_released("left"):
		_set_states(SPEED_STATE.IDLE,-1)
	velocity =  move_and_slide(velocity,Vector2.UP)
	velocity.x = lerp(velocity.x,0,0.2)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpforce
	velocity.y = velocity.y + gravity
	
	if Input.is_action_pressed("primary_weapon"):
		if reloading == false:
			reloading = true
			var firball = FIREBALL.instance()
			firball.set_firball_direction(sign($Position2D.position.x))
			get_parent().add_child(firball)
			firball.position = $Position2D.global_position
			yield(get_tree().create_timer(reload_time),"timeout")
			reloading = false
		
		
	if Input.is_action_just_pressed("ui_down") and sqtSt == SQUAT_STATE.NONE:
		TapCountDown += 1
		if TapCountDown == 2:
			_set_states(-1,SQUAT_STATE.STKY)
		else:
			_set_states(-1,SQUAT_STATE.TEMP)
		yield(get_tree().create_timer(.2),"timeout")
		TapCountDown = 0
	if Input.is_action_just_released("ui_down") and sqtSt != SQUAT_STATE.STKY:
		_set_states(-1,SQUAT_STATE.NONE)
	if Input.is_action_just_pressed("ui_up"):
		_set_states(-1,SQUAT_STATE.NONE)

func _set_states(new_spdSt: int=-1, new_sqtSt: int=-1) -> void:
	if new_spdSt < 0:
		new_spdSt=spdSt
	if new_sqtSt < 0:
		new_sqtSt=sqtSt
	if new_spdSt != spdSt:
		print("[steve._set_states] Changing SPEED_STATE from %s to %s" % [SPEED_STATE.keys()[spdSt],SPEED_STATE.keys()[new_spdSt]] )
	if new_sqtSt != sqtSt:
		print("[steve._set_states] Changing SQUAT_STATE from %s to %s" % [SQUAT_STATE.keys()[sqtSt],SQUAT_STATE.keys()[new_sqtSt]] )
	if new_spdSt != spdSt or new_sqtSt != sqtSt:
		sqtSt = new_sqtSt
		spdSt = new_spdSt 
		if sqtSt == SQUAT_STATE.NONE:
			dynamicSpeedModifier = 1.0
			$CxnShp2D_Stand.set_deferred("disabled",false)
			$CxnShp2D_Squat.set_deferred("disabled",true)
			if spdSt == SPEED_STATE.IDLE:
				$Sprite.play("idle")
			if spdSt == SPEED_STATE.WALK:
				$Sprite.play("walk")
		else:
			dynamicSpeedModifier = 0.3
			$CxnShp2D_Stand.set_deferred("disabled",true)
			$CxnShp2D_Squat.set_deferred("disabled",false)
			if spdSt == SPEED_STATE.IDLE:
				$Sprite.play("squat_idle")
			if spdSt == SPEED_STATE.WALK:
				$Sprite.play("squat_walk")

	
		
func _on_fallzone_body_entered(body):
	get_tree().change_scene("res://scenes/lvls/lvl1_intro_cave/Level1.tscn")

func bounce():
	velocity.y = jumpforce*0.5
	



func _on_Timer_timeout():
	if hp > 0:
		set_modulate(Color(1,1,1,1))
	else:
		get_tree().change_scene("res://scenes/lvls/lvl1_intro_cave/Level1.tscn")

