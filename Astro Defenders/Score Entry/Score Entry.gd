extends Node2D

var change_scene_to_file = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Name Entry".grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if change_scene_to_file:
		get_tree().change_scene_to_file("res://Main Menu/Main Menu.tscn")


func _on_Name_Entry_text_entered(new_text):
	var entry = {"name" : new_text, "score" : GameVariables.score}
	GameVariables.add_score(entry)
	change_scene_to_file = true
