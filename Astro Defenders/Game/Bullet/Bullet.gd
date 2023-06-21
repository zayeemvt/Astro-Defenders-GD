extends Area2D

@export var speed: int = 1000

var direction := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed * delta
		
		global_position += velocity
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hit():
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_area_entered(area):
	if area.has_method("hit"):
		area.hit()
		queue_free()
