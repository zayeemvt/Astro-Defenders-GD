extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (Input.is_action_just_pressed("player_shoot")):
		var entry = {"name" : "New_Player", "score" : GameVariables.score}
		GameVariables.add_score(entry)
		get_tree().change_scene("res://Main Menu/Main Menu.tscn")
