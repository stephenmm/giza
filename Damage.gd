extends Object
class_name Damage

enum Type {BASE, KINETIC, HEAT, TOXIC, RADIATION, PERCUSIVE, ELECTRIC, FREEZE}

var amount:float
var type:int
var dmgs:Dictionary

func append( amount:float, type:int=Type.BASE ) -> bool:
	if !Type.has(type):
		push_error("Attempt to add an invalid damage type to the Damage class")
		assert(false)
		get_tree().quit()
		return false
	if dmgs.has(type):
		push_error("Attempt to add damage type that already exists")
		assert(false)
		get_tree().quit()
		return false
	dmgs[type] = amount
	return true
