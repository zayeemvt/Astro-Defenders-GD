extends Node2D

enum SETTINGS { AUDIO, UP, DOWN, LEFT, RIGHT, SHOOT, BACK }

onready var node_list = [ [$"Options/Audio/Music", $"Options/Audio/Sound"], 
						  [$"Options/Up/Key1", $"Options/Up/Key2"], 
						  [$"Options/Down/Key1", $"Options/Down/Key2"], 
						  [$"Options/Left/Key1", $"Options/Left/Key2"], 
						  [$"Options/Right/Key1", $"Options/Right/Key2"], 
						  [$"Options/Shoot/Key1", $"Options/Shoot/Key2"], 
						  [$"Options/Back/Action", $"Options/Back/Action"]]
onready var cursor = $"Menu Cursor"

onready var x_offset = int(cursor.frames.get_frame("default", 0).get_size().x / 2)
onready var y_offset = int(node_list[0][0].rect_size.y / 2)

var cursor_pos = {"x" : 0, "y" : 0}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if Input.is_action_just_pressed("player_down"):
		cursor_pos.y = (cursor_pos.y + 1) % 7
	if Input.is_action_just_pressed("player_up"):
		cursor_pos.y = (cursor_pos.y + 6) % 7
	if Input.is_action_just_pressed("player_left") or \
		Input.is_action_just_pressed("player_right"):
		cursor_pos.x = (cursor_pos.x + 1) % 2
	
	highlight(node_list[cursor_pos.y][cursor_pos.x])
	
	if Input.is_action_just_pressed("player_shoot"):
#		select_option()
		pass

func highlight(node):
	$"Menu Cursor".position.x = (node.get_parent().rect_position.x + node.rect_position.x) - x_offset
	$"Menu Cursor".position.y = node.get_parent().rect_position.y + y_offset
