extends AudioStreamPlayer

var loop = false
var loop_start = 0
var loop_end = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_song(song: AudioStream, volume = -6, loop = false, start = 0, end = 0):
	stream = song
	self.loop = loop
	loop_start = start
	loop_end = end
	
	volume_db = volume
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func _on_MusicPlayer_finished():
#	if loop:
#		play()
