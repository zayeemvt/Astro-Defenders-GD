extends Node

enum MENU_OPTIONS { PLAY, INSTRUCTIONS, HIGH_SCORES, SETTINGS, CREDITS }

var cur_selection = MENU_OPTIONS.PLAY
var menu = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
