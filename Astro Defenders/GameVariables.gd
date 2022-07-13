extends Node

var score = 0
var high_scores = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0, 5):
		var player_name = "Player " + str(i)
		high_scores.append({"name" : player_name, "score" : 0 })


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func sort_scores():
	var new_high_score = false
	
	for i in range(0, high_scores.size()):
		if score > high_scores[i].score:
			var temp = score
			score = high_scores[i].score
			high_scores[i].score = temp
			
			new_high_score = true
	
	return new_high_score
