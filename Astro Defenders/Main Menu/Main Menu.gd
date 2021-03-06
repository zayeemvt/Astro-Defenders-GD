extends Node2D

onready var node_list = [$"Selections/Play", $"Selections/Instructions", $"Selections/High Scores",
				 $"Selections/Settings", $"Selections/Credits", $"Selections/Quit"]
onready var cursor = $"Menu Cursor"

onready var offset = int(node_list[0].rect_size.y / 2)

var bgm = preload("res://Music/MM2 - Password.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	if (Global.menu == false):
		MusicPlayer.stream = bgm
		MusicPlayer.play()
		Global.menu = true
		
	highlight(node_list[Global.cur_selection])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
#	unhighlight(node_list[Global.cur_selection])
	
	if Input.is_action_just_pressed("player_down"):
		Global.cur_selection = (Global.cur_selection + 1) % 6
		cursor.get_node("Sound").play()
	if Input.is_action_just_pressed("player_up"):
		Global.cur_selection = (Global.cur_selection + 5) % 6
		cursor.get_node("Sound").play()
	
	highlight(node_list[Global.cur_selection])
	
	if Input.is_action_just_pressed("player_shoot"):
		select_option()
		cursor.get_node("Sound").play()

func highlight(node):
#	node.add_color_override("font_color", Color(0.20, 0.33, 1, 1))
	$"Menu Cursor".position.y = node.rect_position.y + offset

func unhighlight(node):
#	node.add_color_override("font_color", Color(1, 1, 1, 1))
	pass

func select_option():
	match Global.cur_selection:
		Global.MENU_OPTIONS.PLAY:
			Global.menu = false
			get_tree().change_scene("res://Game/Game.tscn")
		Global.MENU_OPTIONS.INSTRUCTIONS:
			pass
		Global.MENU_OPTIONS.HIGH_SCORES:
			get_tree().change_scene("res://Main Menu/High Scores/High Scores.tscn")
		Global.MENU_OPTIONS.SETTINGS:
			get_tree().change_scene("res://Main Menu/Settings/Settings.tscn")
		Global.MENU_OPTIONS.CREDITS:
			pass
		Global.MENU_OPTIONS.QUIT:
			get_tree().quit()
