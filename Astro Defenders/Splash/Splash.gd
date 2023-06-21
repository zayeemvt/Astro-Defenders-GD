extends Node2D

var progress: float = 0

const bgm = preload("res://Music/MM2 - Victory.wav")
const SETTINGS_FILE = "user://settings.cfg"

# Called when the node enters the scene tree for the first time.
func _ready():
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_FILE)
	if not err:
		var volume = [config.get_value("audio", "Music"), config.get_value("audio", "Sound")]
		var audio_bus_indices = [AudioServer.get_bus_index("Music"), AudioServer.get_bus_index("Sound")]
		
		for i in range(0, volume.size()):
			var db = 20 * log(float(volume[i])/100) / log(10)
			db = clamp(db, -60, 0)
			AudioServer.set_bus_volume_db(audio_bus_indices[i], db)
		
	MusicPlayer.stream = bgm
	MusicPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	progress += 0.68
	$ProgressBar.value = int(progress)


func _on_Timer_timeout():
	MusicPlayer.stop()
	get_tree().change_scene_to_file("res://Main Menu/Main Menu.tscn")
