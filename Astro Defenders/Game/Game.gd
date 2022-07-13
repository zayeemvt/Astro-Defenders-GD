extends Node2D

var bgm = preload("res://Music/BGM/MM5 - Gravity Man.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicPlayer.load_song(bgm, -12)
	$Player.connect("player_dead", $Spawner, "_on_Player_player_dead")
	$Player.connect("player_dead", self, "_on_Player_player_dead")
	$Player.connect("update_lives", $"Game HUD", "_on_Player_update_lives")
	$Spawner.connect("enemy_off_screen", $Player, "_on_Enemy_enemy_off_screen")
	$Spawner.connect("update_score", $"Game HUD", "_on_Spawner_update_score")
	MusicPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Player_player_dead():
	for child in get_children():
		if child.is_in_group("Projectile"):
			remove_child(child)
