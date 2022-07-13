extends Node2D

var progress: float = 0

var bgm = preload("res://Music/BGM/MM2 - Victory.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicPlayer.stream = bgm
	MusicPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	progress += 0.68
	$ProgressBar.value = int(progress)


func _on_Timer_timeout():
	MusicPlayer.stop()
	get_tree().change_scene("res://Main Menu/Main Menu.tscn")
