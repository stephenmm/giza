extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng

func _init():
	rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu/CenterRow/Buttons/NewGame.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_NewGame_pressed():
	get_tree().change_scene("res://scenes/lvls/lvl1_intro_cave/Level1.tscn")
