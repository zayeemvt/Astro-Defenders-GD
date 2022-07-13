extends Node2D

var bgm = preload("res://Music/BGM/MM3 - Weapon Get.ogg")

var new_high_score

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicPlayer.load_song(bgm, -9)
	$"Score".text = str(GameVariables.score).pad_zeros(6)
	new_high_score = GameVariables.sort_scores()
	MusicPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (Input.is_action_just_pressed("player_shoot")):
		if (new_high_score):
			get_tree().change_scene("res://Score Entry/Score Entry.tscn")
		else:
			get_tree().change_scene("res://Main Menu/Main Menu.tscn")
