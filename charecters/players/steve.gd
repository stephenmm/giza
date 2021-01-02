extends BaseChar
class_name steve

const FIREBALL = preload("res://models/items/fireball/Fireball.tscn")
enum SPEED_STATE {NOCHG, IDLE, CRAWL, WALK, RUN}
enum SQUAT_STATE {NOCHG, OFF, TEMP, STKY}
var spdSt
var sqtSt
var jmpSt
var downTapCnt = 0
var rightTapCnt = 0
var leftTapCnt = 0
var reloading
var reload_time
var gun_energy_per_bullet = 5.0
var jump_energy_required = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	spdSt=SPEED_STATE.IDLE
	sqtSt=SQUAT_STATE.OFF
	jmpSt=0
	$CxnShp2D_Stand.disabled = false
	$CxnShp2D_Squat.disabled = true
	derivedCharSpeedModifier = 1.5	
	reloading = false
	reload_time = 0.5
	#get_node("/root/Level1/HUD/HealthBar").value = 100.0*(hp/max_hp)
	#get_node("/root/Level1/HUD/HealthBar").value = 100.0*(hp/max_hp)
	#$HUD.HealthB = int(100*(hp/max_hp))
	#get_tree().get_root().get_node("HealthBar").Value = 100*(hp/max_hp)

func get_charecter_type(): 
	return "player"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _get_horizontal_speed() -> float:
	var speed: float = baseCharSpeed * derivedCharSpeedModifier * dynamicSpeedModifier
	#print(speed)
	if sqtSt != SQUAT_STATE.OFF:
		speed *= 0.5
	if spdSt == SPEED_STATE.IDLE:
		speed *= 0
	if spdSt == SPEED_STATE.RUN:
		speed *= 1.5
	speed *= direction
	#print(speed)
	return speed
	
func _get_energy_generation() -> float: # Override BaseChar implementation
	var nrgxn = energy_generation 
	if sqtSt != SQUAT_STATE.OFF: # In some sort of squat state
		nrgxn *= 2
	return nrgxn

func _set_char_direction(dir):
	if sign($Position2D.position.x) != dir:
		$Position2D.position.x *= -1
	$Sprite.flip_h = (dir>0)
	direction = dir
	return dir
#func _calc_drive_energy_consuption( speed, motor_peak_efficiency ) # 60-95%

func _physics_process(delta):
	._physics_process(delta)
	var _jump_nrg = 0.0
	var _horz_nrg = 0.0
	var _pgun_nrg = 0.0
	var _sgun_nrg = 0.0
	
	if Input.is_action_pressed("right"):
		_set_states( SPEED_STATE.WALK, SQUAT_STATE.NOCHG, 1 )
	elif Input.is_action_pressed("left"):
		_set_states( SPEED_STATE.WALK, SQUAT_STATE.NOCHG, -1 )
	if Input.is_action_just_released("right") or Input.is_action_just_released("left"):
		_set_states( SPEED_STATE.IDLE, SQUAT_STATE.NOCHG )
	
	if Input.is_action_just_pressed("ui_down") and sqtSt == SQUAT_STATE.OFF:
		downTapCnt += 1
		if downTapCnt == 2:
			_set_states( SPEED_STATE.NOCHG, SQUAT_STATE.STKY )
		else:
			_set_states( SPEED_STATE.NOCHG, SQUAT_STATE.TEMP )
		yield(get_tree().create_timer(.2),"timeout")
		downTapCnt = 0
	if Input.is_action_just_released("ui_down") or Input.is_action_just_pressed("ui_up"):
		_set_states( SPEED_STATE.NOCHG, SQUAT_STATE.OFF )


	vel.x = lerp(vel.x,_get_horizontal_speed(),0.2)
	#Applying gravity to player
	vel.y += gravity 

	#Jump Physics
	if vel.y > 0:                                             #Player is falling
		vel.y += gravity * fallMultiplier                     #Falling action is faster than jumping action
	elif Input.is_action_just_released("jump"):               #Player is jumping 
		vel.y += gravity * fallMultiplier * lowJumpMultiplier #Fall really fast once jump is released

	if Input.is_action_just_pressed("jump") and is_on_floor(): 
		var jfSqtMod=1.0
		if (sqtSt > SQUAT_STATE.OFF): 
			jfSqtMod=1.25
		if energy_stored > jump_energy_required * jfSqtMod:
			vel.y = jumpforce * jfSqtMod
			energy_stored -= jump_energy_required * jfSqtMod
 
	vel =  move_and_slide(vel,Vector2.UP)
	
	if Input.is_action_pressed("primary_weapon"):
		if energy_stored > gun_energy_per_bullet:
			if reloading == false:
				reloading = true
				var firball = FIREBALL.instance()
				firball.set_firball_direction(sign($Position2D.position.x))
				get_parent().add_child(firball)
				firball.position = $Position2D.global_position
				energy_stored -= gun_energy_per_bullet
				yield(get_tree().create_timer(reload_time),"timeout")
				reloading = false
		
		
	get_node("/root/Level1/HUD/EnergyBar").value = 100.0*(energy_stored/energy_stored_max)


func _set_states(new_spdSt: int=SPEED_STATE.NOCHG, new_sqtSt: int=SQUAT_STATE.NOCHG, new_dir: int=0 ) -> void:
	if new_spdSt == SPEED_STATE.NOCHG:
		new_spdSt=spdSt
	if new_sqtSt == SQUAT_STATE.NOCHG:
		new_sqtSt=sqtSt
	if new_dir==0:
		new_dir=direction
	if new_spdSt != spdSt:
		print("[steve._set_states] Changing SPEED_STATE from %s to %s" % [SPEED_STATE.keys()[spdSt],SPEED_STATE.keys()[new_spdSt]] )
	if new_sqtSt != sqtSt:
		print("[steve._set_states] Changing SQUAT_STATE from %s to %s" % [SQUAT_STATE.keys()[sqtSt],SQUAT_STATE.keys()[new_sqtSt]] )
	if new_spdSt != spdSt or new_sqtSt != sqtSt:
		sqtSt = new_sqtSt
		spdSt = new_spdSt 
		if sqtSt == SQUAT_STATE.OFF:
			$CxnShp2D_Stand.set_deferred("disabled",false)
			$CxnShp2D_Squat.set_deferred("disabled",true)
			if spdSt == SPEED_STATE.IDLE:
				$Sprite.play("idle")
			if spdSt == SPEED_STATE.WALK:
				$Sprite.play("walk")
		else:
			$CxnShp2D_Stand.set_deferred("disabled",true)
			$CxnShp2D_Squat.set_deferred("disabled",false)
			if spdSt == SPEED_STATE.IDLE:
				$Sprite.play("squat_idle")
			if spdSt == SPEED_STATE.WALK:
				$Sprite.play("squat_walk")
		direction=_set_char_direction(new_dir)
		print("[steve._set_states] New speed is %f" % [_get_horizontal_speed()] )
	
		
func _on_fallzone_body_entered(body):
	get_tree().change_scene("res://scenes/lvls/lvl1_intro_cave/Level1.tscn")

func bounce():
	vel.y = jumpforce*0.5

func ingressAttack( dmg: Damage, enemy_pos=null ):
	.ingressAttack( dmg, enemy_pos )
	get_node("/root/Level1/HUD/HealthBar").value = 100.0*(hp/max_hp)
	print("Recieved dmgAmnt: %f of dmgType %d REMAINING HP:%f" % [dmg.amount, dmg.type, hp])


func _on_Timer_timeout():
	if hp > 0:
		set_modulate(Color(1,1,1,1))
	else:
		get_tree().change_scene("res://scenes/lvls/lvl1_intro_cave/Level1.tscn")

