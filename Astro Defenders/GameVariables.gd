extends Node

var score = 0
var high_scores = []

var score_file = "user://scores.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	var file
	if FileAccess.file_exists(score_file):
		file = FileAccess.open(score_file, FileAccess.READ)
		var test_json_conv = JSON.new()
		test_json_conv.parse(file.get_line())
		high_scores = test_json_conv.get_data()
	else:
		for i in range(0, 5):
			var player_name = "Player " + str(i)
			high_scores.append({"name" : player_name, "score" : 0 })


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func check_score():
	for entry in high_scores:
		if score > entry.score:
			return true
	
	return false

func add_score(entry):
	for i in range(0, high_scores.size()):
		if entry.score > high_scores[i].score:
			var temp = entry
			entry = high_scores[i]
			high_scores[i] = temp
	
	save_scores()

func save_scores():
	var file = FileAccess.open(score_file, FileAccess.WRITE)
	file.store_line(JSON.stringify(high_scores))
