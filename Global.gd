extends Node
class_name Global

export var mySeed: int = 0
var rng = RandomNumberGenerator.new()

func _init():
	if mySeed != 0:
		rng.set_seed(mySeed)

