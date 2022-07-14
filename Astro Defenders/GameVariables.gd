extends Node

var score = 0
var high_scores = []

var score_file = "user://scores.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	if file.file_exists(score_file):
		file.open(score_file, File.READ)
		high_scores = parse_json(file.get_line())
	else:
		for i in range(0, 5):
			var player_name = "Player " + str(i)
			high_scores.append({"name" : player_name, "score" : 0 })
	
	file.close()


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
	var file = File.new()
	file.open(score_file, File.WRITE)
	file.store_line(to_json(high_scores))
