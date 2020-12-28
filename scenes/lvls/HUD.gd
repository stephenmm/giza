extends CanvasLayer
# Taken from here: 
#    https://kidscancode.org/godot_recipes/games/circle_jump/circle_jump_05/
#    https://www.youtube.com/watch?v=Fz2ltnvI4MQ


var health = 100



## Called when the node enters the scene tree for the first time.
#func _ready():
#	$Health.text = String(health)
#
#func update_health(value):
#	$Health.text = String(value)


func show_message(text):
	$Message.text = text
	$AnimationPlayer.play("show_message")
	
func hide():
	$ScoreBox.hide()
	
func show():
	$ScoreBox.show()
	
func update_health(value):
	$ScoreBox/HBoxContainer/Health.text = str(value)
