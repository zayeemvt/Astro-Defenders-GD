extends Node2D

var bgm = preload("res://Music/MM5 - Gravity Man.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicPlayer.stream = bgm
	$Player.connect("player_dead", Callable(self, "_on_Player_player_dead"))
	$Player.connect("update_lives", Callable($"Game HUD", "_on_Player_update_lives"))
	$Spawner.connect("enemy_off_screen", Callable($Player, "_on_Enemy_enemy_off_screen"))
	$Spawner.connect("update_score", Callable($"Game HUD", "_on_Spawner_update_score"))
	MusicPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Player_player_dead():
	get_tree().change_scene_to_file("res://Game Over/Game Over.tscn")
