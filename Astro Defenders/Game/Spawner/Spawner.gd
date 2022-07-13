extends Node2D

var junk = preload("res://Game/Enemy/Junk/Junk.tscn")
var meteor = preload("res://Game/Enemy/Meteor/Meteor.tscn")
export (int) var max_enemies = 30
var enemies_spawned = 0
var rng = RandomNumberGenerator.new()

var score_thresholds = [0,0,0,0,0,0]
var cur_threshold = GameVariables.score

var spawn_intervals = [3, 2, 1, 0.5, 0.25, 0.15, 0.10]
var difficulty = 0
var timer_time = spawn_intervals[difficulty]

var meteor_table = [2, 3, 6, 10, 15, 20, 30]
var meteor_goals = [1, 2, 3, 5, 10, 20]
var junk_counter = 0

onready var region = get_node("Spawn Region/CollisionShape2D")
onready var center = region.position
onready var size = region.shape.extents

signal update_score
signal enemy_off_screen

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	$Timer.start(timer_time)
	
	var junk_data = junk.instance()
	var meteor_data = meteor.instance()

	var junk_score = junk_data.score
	var meteor_score = meteor_data.score
	
	for i in range(0,score_thresholds.size()):
		score_thresholds[i] = meteor_table[i]*junk_score + meteor_goals[i]*meteor_score


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if enemies_spawned < max_enemies:
		var enemy = null
		
		if (junk_counter == meteor_table[difficulty]):
				enemy = meteor
				junk_counter = 0
		else:
			enemy = junk
			junk_counter += 1
		
		var enemy_instance = enemy.instance()
		var spawn_point = rng.randi_range(-size.x, size.x) + center.x
		enemy_instance.position = Vector2(spawn_point, center.y)
		enemy_instance.connect("enemy_despawn", self, "_on_Enemy_enemy_despawn")
		enemy_instance.connect("enemy_off_screen", self, "_on_Enemy_enemy_off_screen")
		enemies_spawned += 1
		add_child(enemy_instance)
	
#	print(timer_time)
	$Timer.start(timer_time)

func _on_Enemy_enemy_despawn(score):
	enemies_spawned -= 1
	if score > 0:
		emit_signal("update_score", score)
		
		for threshold in score_thresholds:
			if (GameVariables.score >= threshold) and (threshold > cur_threshold):
				cur_threshold = threshold
				_increase_difficulty()

func _increase_difficulty():
	difficulty += 1
	timer_time = spawn_intervals[difficulty]
	print("Difficulty: " + str(difficulty))

func _on_Enemy_enemy_off_screen():
	emit_signal("enemy_off_screen")

