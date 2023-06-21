extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	GameVariables.score = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Spawner_update_score(score):
	GameVariables.score += score
	var score_text = "%06d" % [GameVariables.score]
	$"Score Value".text = score_text

func _on_Player_update_lives(lives):
	match lives:
		0:
			$Lives/Life1.hide()
		1:
			$Lives/Life2.hide()
		2:
			$Lives/Life3.hide()
	
