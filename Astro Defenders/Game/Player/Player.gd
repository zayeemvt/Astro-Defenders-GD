extends KinematicBody2D
class_name Player

export (int) var speed = 350

var bullet = preload("res://Game/Bullet/Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var movement_direction := Vector2.ZERO
	
	if Input.is_action_pressed("player_up"):
		movement_direction.y = -1
	if Input.is_action_pressed("player_down"):
		movement_direction.y = 1
		
	if Input.is_action_pressed("player_left"):
		movement_direction.x = -1
	if Input.is_action_pressed("player_right"):
		movement_direction.x = 1
		
	movement_direction = movement_direction.normalized()
	move_and_slide(movement_direction * speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("player_shoot"):
		if $"Fire Timer".is_stopped():
			var bullet_instance = bullet.instance()
			bullet_instance.global_position = $"Laser Point".global_position
			bullet_instance.direction = Vector2(0, -1)
			get_parent().add_child(bullet_instance)
			$"Fire Timer".start()

