extends KinematicBody2D
class_name BaseChar

# Declare member variables here. Examples:
export var max_hp: float = 100.0
var hp: float = max_hp
export var energy_stored_max: float = 100.0     # Related to battery size * charge density
var energy_stored: float = energy_stored_max * 0.9 # Start off with a little less than max
export var energy_generation: float = 1.0       # energy units generated per second
var vel = Vector2(0,0)
const baseCharSpeed: float = 100.0
export var derivedCharSpeedModifier = 1.0
export var gravity = 20.0
export var jumpforce = -350.0
export var fallMultiplier = 1.0
export var lowJumpMultiplier = 5
export var baseDamage: float = 50.0

var dynamicSpeedModifier: float = 1.0

var ingressDmgModifiers:Dictionary
var  egressDmgModifiers:Dictionary

export var direction = -1 # 1=right, -1=left

func _init():
	for dmgType in Damage.DMGTYPE:
		ingressDmgModifiers[dmgType] = 0.0
		egressDmgModifiers[dmgType] = 0.0

func _get_default_speed() -> float:
	return baseCharSpeed * derivedCharSpeedModifier * dynamicSpeedModifier

func _physics_process(delta):
	energy_stored += _get_energy_generation()*delta
	if energy_stored > energy_stored_max:
		energy_stored = energy_stored_max
		
func _get_energy_generation():
	return energy_generation
	
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
	
	vel.y = jumpforce * 0.4
	
	if enemy_pos != null:
		if position.x < enemy_pos.x:
			vel.x = -jumpforce * 0.6
		elif position.x > enemy_pos.x:
			vel.x = -jumpforce * 0.6
	
	# Taking over control of the charecter 
	Input.action_release("left")
	Input.action_release("right")
	#for dmg in ingressDmg.dmgs.values():
	#	# In the future we can add resistance to certain types of damage but for now subtract all damage types from HP
	#	hp -= dmg
	hp -= dmg.amount

	$Timer.start()
