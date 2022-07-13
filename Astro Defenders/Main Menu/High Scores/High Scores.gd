extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var high_scores = GameVariables.high_scores
	
	var i = 0
	for node in $Scores.get_children():
		node.get_node("Name").text = high_scores[i].name
		node.get_node("Value").text = str(high_scores[i].score).pad_zeros(6)
		i += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (Input.is_action_just_pressed("player_shoot")):
		get_tree().change_scene("res://Main Menu/Main Menu.tscn")
