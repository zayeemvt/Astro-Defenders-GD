extends Node


class Song:
	var name
	var path
	var db
	var loop = false


var song_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func get_BGM(track_name: String):
	var song = song_list.find(track_name)
	return song
