extends Enemy

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _init():
	base_speed = 50
	max_speed = 200
	score = 500
	speed = base_speed
	
	health = 1
