extends Area2D

export (int) var base_speed = 50
export (int) var max_speed = 200
export (int) var score = 500
var speed = base_speed

signal junk_despawn
signal junk_off_screen

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	speed = rng.randi_range(base_speed, max_speed)
	connect("junk_despawn", get_parent(), "_on_Junk_junk_despawn")
	connect("junk_off_screen", get_node("../../Player"), "_on_Junk_junk_off_screen")

func _physics_process(delta: float) -> void:
	var velocity = Vector2(0,1) * speed * delta
	
	global_position += velocity
	
	# Junk is off-screen
	if global_position.y > 600 + $CollisionShape2D.shape.extents.y:
		emit_signal("junk_despawn", 0)
		emit_signal("junk_off_screen")
		queue_free()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hit():
	emit_signal("junk_despawn", score)
	queue_free()

func _on_Junk_body_entered(body):
	if body.has_method("hit"):
		body.hit()
		queue_free()

func _on_Junk_area_entered(area):
	if area.has_method("hit"):
		area.hit()
		queue_free()
		
