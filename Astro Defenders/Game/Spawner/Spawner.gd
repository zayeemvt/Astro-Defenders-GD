extends Node2D

var enemy = preload("res://Game/Enemy/Junk.tscn")
export (int) var max_enemies = 20
var enemies_spawned = 0
var rng = RandomNumberGenerator.new()

var score = 0
var score_thresholds = {0:3, 1000:2, 3000:1, 6000:0.5, 25000:0.25, 50000:0.15}
var timer_time = score_thresholds[0]

onready var region = get_node("Spawn Region/CollisionShape2D")
onready var center = region.position
onready var size = region.shape.extents

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	$Timer.start(timer_time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if enemies_spawned < max_enemies:
		var enemy_instance = enemy.instance()
		var spawn_point = rng.randi_range(-size.x, size.x)
		enemy_instance.position = Vector2(spawn_point, center.y)
		enemies_spawned += 1
		add_child(enemy_instance)
	
	for key in score_thresholds.keys():
		if self.score >= key:
			timer_time = score_thresholds[key]
	
	print(timer_time)
	$Timer.start(timer_time)

func _on_Junk_junk_despawn(score):
	enemies_spawned -= 1
	self.score += score

func _on_Player_player_dead():
	for child in get_children():
		if child.is_in_group("Enemy"):
			queue_free()
