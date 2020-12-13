extends Object
class_name Damage

enum DMGTYPE {GENERIC, KINETIC, HEAT, TOXIC, RADIATION, PERCUSIVE, ELECTRIC, FREEZE}

var amount:float
var type:int
var dmgs:Dictionary

func _init( amnt:float=0.0, typ:int=DMGTYPE.GENERIC ):
	amount = amnt
	type = typ
	append(amnt,typ)

func append( amnt:float, typ:int=DMGTYPE.GENERIC ) -> bool:
	#if !DMGTYPE.has(typ):
	#	push_error("Attempt to add an invalid damage type to the Damage class")
	#	assert(false)
	#	#get_tree().quit()
	#	return false
	if dmgs.has(typ):
		push_error("Attempt to add damage type that already exists")
		assert(false)
		#get_tree().quit()
		return false
	dmgs[typ] = amnt
	return true
