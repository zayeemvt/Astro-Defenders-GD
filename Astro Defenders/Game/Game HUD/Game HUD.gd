extends Node2D


var score = 0
var score_thresholds = [1000, 3000, 6000, 25000, 50000]
var cur_threshold = score

signal increase_difficulty

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Spawner_update_score(score):
	self.score += score
	var score_text = "%06d" % [self.score]
	$"Score Value".text = score_text
	
	for threshold in score_thresholds:
		if (self.score >= threshold) and (threshold > cur_threshold):
			print(self.score)
			print(threshold)
			print(cur_threshold)
			cur_threshold = threshold
			emit_signal("increase_difficulty")

func _on_Player_update_lives(lives):
	match lives:
		0:
			$Lives/Life1.hide()
			continue
		1:
			$Lives/Life2.hide()
			continue
		2:
			$Lives/Life3.hide()
	
