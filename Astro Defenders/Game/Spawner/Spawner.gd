extends Node2D

var enemy = preload("res://Game/Enemy/Junk.tscn")
export (int) var max_enemies = 20
var enemies_spawned = 0
var rng = RandomNumberGenerator.new()

var spawn_intervals = [3, 2, 1, 0.5, 0.25, 0.15]
var difficulty = 0
var timer_time = spawn_intervals[difficulty]

onready var region = get_node("Spawn Region/CollisionShape2D")
onready var center = region.position
onready var size = region.shape.extents

signal update_score
signal junk_off_screen

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
		var spawn_point = rng.randi_range(-size.x, size.x) + center.x
		enemy_instance.position = Vector2(spawn_point, center.y)
		enemy_instance.connect("junk_despawn", self, "_on_Junk_junk_despawn")
		enemy_instance.connect("junk_off_screen", self, "_on_Junk_junk_off_screen")
		enemies_spawned += 1
		add_child(enemy_instance)
	
#	print(timer_time)
	$Timer.start(timer_time)

func _on_Junk_junk_despawn(score):
	enemies_spawned -= 1
	if score > 0:
		emit_signal("update_score", score)

func _on_Player_player_dead():
	for child in get_children():
		if child.is_in_group("Enemy"):
			queue_free()

func _on_Game_HUD_increase_difficulty():
	difficulty += 1
	timer_time = spawn_intervals[difficulty]

func _on_Junk_junk_off_screen():
	emit_signal("junk_off_screen")
