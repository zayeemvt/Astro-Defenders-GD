extends Node2D

var bgm = preload("res://Music/BGM/MM3 - Weapon Get.ogg")


# Called when the node enters the scene tree for the first time.
func _ready():
	MusicPlayer.stream = bgm
	$"Score".text = str(GameVariables.score).pad_zeros(6)
	MusicPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (Input.is_action_just_pressed("player_shoot")):
		if (GameVariables.check_score()):
			get_tree().change_scene("res://Score Entry/Score Entry.tscn")
		else:
			get_tree().change_scene("res://Main Menu/Main Menu.tscn")
