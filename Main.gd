extends Node
class_name Main

export var mySeed: int = 0
var rng = RandomNumberGenerator.new()

func _init():
	if mySeed != 0:
		rng.set_seed(mySeed)

func _ready():
	randomize()
	$HUD.hide()
	
func new_game():
	pass
	
	
