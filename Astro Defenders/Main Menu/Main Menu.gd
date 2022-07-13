extends Node2D

onready var node_list = [$"Selections/Play", $"Selections/Instructions", $"Selections/High Scores",
				 $"Selections/Settings", $"Selections/Credits"]

var bgm = preload("res://Music/BGM/MM2 - Password.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	if (Global.menu == false):
		MusicPlayer.load_song(bgm, -12)
		MusicPlayer.play()
		Global.menu = true
		
	highlight(node_list[Global.cur_selection])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	unhighlight(node_list[Global.cur_selection])
	
	if Input.is_action_just_pressed("player_down"):
		Global.cur_selection = (Global.cur_selection + 1) % 5
	if Input.is_action_just_pressed("player_up"):
		Global.cur_selection = (Global.cur_selection + 4) % 5
	
	highlight(node_list[Global.cur_selection])
	
	if Input.is_action_just_pressed("player_shoot"):
		select_option()

func highlight(node):
	node.add_color_override("font_color", Color(0.20, 0.33, 1, 1))

func unhighlight(node):
	node.add_color_override("font_color", Color(1, 1, 1, 1))

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
			pass
		Global.MENU_OPTIONS.CREDITS:
			pass
