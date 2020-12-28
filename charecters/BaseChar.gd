extends KinematicBody2D
class_name BaseChar

# Declare member variables here. Examples:
export var hp: float = 100.0
export var energy: float = 100.0
var velocity = Vector2(0,0)
const baseCharSpeed: float = 100.0
export var derivedCharSpeedModifier = 1.0
export var gravity = 20
export var jumpforce = -350
export var baseDamage: float = 50.0

var dynamicSpeedModifier: float = 1.0

var ingressDmgModifiers:Dictionary
var  egressDmgModifiers:Dictionary

func _init():
	for dmgType in Damage.DMGTYPE:
		ingressDmgModifiers[dmgType] = 0.0
		egressDmgModifiers[dmgType] = 0.0

func _get_default_speed() -> float:
	return baseCharSpeed * derivedCharSpeedModifier * dynamicSpeedModifier

func ingressDmg(dmgs: Dictionary) -> float:
	var calcDmg: float = calcDmgs(dmgs, ingressDmgModifiers)
	hp -= calcDmg
	return calcDmg
	
func egressDmg(dmgs: Dictionary) -> float:
	return calcDmgs(dmgs, egressDmgModifiers)

func calcDmgs(dmgs: Dictionary, dmgMods: Dictionary) -> float:
	var calcDmg: float = 0.0
	for dmgType in dmgs:
	  calcDmg += dmgs[dmgType] * (1+dmgMods[dmgType])
	return calcDmg

func ingressAttack( dmg: Damage, enemy_pos=null ):
	
	velocity.y = jumpforce * 0.4
	
	if enemy_pos != null:
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
	hp -= dmg.amount
	#$HUD.update_health(hp); # FIXME -- not working
	print("Recieved dmgAmnt: %f of dmgType %d REMAINING HP:%f" % [dmg.amount, dmg.type, hp])
	$Timer.start()
