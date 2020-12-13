extends KinematicBody2D
class_name BaseChar


var hp: float = 100.0
var energy: float = 100.0

var ingressDmgModifiers:Dictionary
var  egressDmgModifiers:Dictionary

func _init():
	for dmgType in Damage.DMGTYPE:
		ingressDmgModifiers[dmgType] = 0.0
		egressDmgModifiers[dmgType] = 0.0

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
