extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.connect("player_dead", $Spawner, "_on_Player_player_dead")
	$Player.connect("update_lives", $"Game HUD", "_on_Player_update_lives")
	$Spawner.connect("junk_off_screen", $Player, "_on_Junk_junk_off_screen")
	$Spawner.connect("update_score", $"Game HUD", "_on_Spawner_update_score")
	$"Game HUD".connect("increase_difficulty", $Spawner, "_on_Game_HUD_increase_difficulty")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass