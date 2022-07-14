extends Area2D
class_name Enemy

export (int) var base_speed = 50
export (int) var max_speed = 200
export (int) var score = 500
var speed = base_speed

export (int) var health = 1

signal enemy_despawn
signal enemy_off_screen

# Called when the node enters the scene tree for the first time.
func _ready():	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	speed = rng.randi_range(base_speed, max_speed)
	
	connect("body_entered", self, "_on_Enemy_body_entered")

func _physics_process(delta: float) -> void:
	if (health > 0):
		var velocity = Vector2.DOWN * speed * delta
		
		global_position += velocity
		
		# Junk is off-screen
		if global_position.y > 600 + $Hitbox.shape.extents.y:
			emit_signal("enemy_despawn", 0)
			emit_signal("enemy_off_screen")
			queue_free()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hit():
	health -= 1
	
	if health == 0:
		$EnemyDefeated.play()
		emit_signal("enemy_despawn", score)
		$Hitbox.set_deferred("disabled", true)

func _on_Enemy_body_entered(body):
	if body.has_method("hit"):
		body.hit()
		queue_free()
		

func _on_EnemyDefeated_finished():
	queue_free()
