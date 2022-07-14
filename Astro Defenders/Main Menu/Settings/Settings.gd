extends Node2D

enum SETTINGS { AUDIO, UP, DOWN, LEFT, RIGHT, SHOOT, BACK }
enum CONFIG { AUDIO, CONTROL, NONE }

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

onready var audio_bus_indices = [AudioServer.get_bus_index("Music"), AudioServer.get_bus_index("Sound")]

const input_actions = [ "player_up", "player_down", "player_left", "player_right", "player_shoot"]

var cursor_pos = {"x" : 0, "y" : 0}
var config_state = CONFIG.NONE
var discard_input = false

var volume = []
var keybinds = []

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(false) # only reactivate when remapping keybinds
	
	volume = [100, 100]
	
	for action in input_actions:
		keybinds.append(InputMap.get_action_list(action))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match config_state:
		CONFIG.NONE:
			move_cursor()
		CONFIG.AUDIO:
			adjust_audio(node_list[cursor_pos.y][cursor_pos.x])
		CONFIG.CONTROL:
			pass # wait for input
	

func highlight(node):
	$"Menu Cursor".position.x = (node.get_parent().rect_position.x + node.rect_position.x) - x_offset
	$"Menu Cursor".position.y = node.get_parent().rect_position.y + y_offset


func move_cursor():
	if Input.is_action_just_pressed("player_down"):
		cursor_pos.y = (cursor_pos.y + 1) % 7
		cursor.get_node("Sound").play()
	if Input.is_action_just_pressed("player_up"):
		cursor_pos.y = (cursor_pos.y + 6) % 7
		cursor.get_node("Sound").play()
	if Input.is_action_just_pressed("player_left") or \
		Input.is_action_just_pressed("player_right"):
		cursor_pos.x = (cursor_pos.x + 1) % 2
		cursor.get_node("Sound").play()
	
	highlight(node_list[cursor_pos.y][cursor_pos.x])
	
	if discard_input:
		# If mapping "player_shoot" to any other action,
		# this prevents the other block from re-triggering
		discard_input = false
	elif Input.is_action_just_pressed("player_shoot"):
		select_option()
		cursor.get_node("Sound").play()


func select_option():	
	if (cursor_pos.y == SETTINGS.BACK):
		get_tree().change_scene("res://Main Menu/Main Menu.tscn")
	else:
		cursor.playing = false
		cursor.frame = 0
		
		if (cursor_pos.y == SETTINGS.AUDIO):
			config_state = CONFIG.AUDIO
		else:
			config_state = CONFIG.CONTROL
			set_process_input(true)
			discard_input = true # prevents "player_shoot" from triggering input event
			


func adjust_audio(node):
	if Input.is_action_just_pressed("player_down"):
		if volume[cursor_pos.x] > 0:
			volume[cursor_pos.x] -= 10
			node.get_node("Volume").text = str(volume[cursor_pos.x]) + "%"
	if Input.is_action_just_pressed("player_up"):
		if volume[cursor_pos.x] < 100:
			volume[cursor_pos.x] += 10
			node.get_node("Volume").text = str(volume[cursor_pos.x]) + "%"
	
	if Input.is_action_just_pressed("player_shoot"):
		config_state = CONFIG.NONE
		cursor.playing = true
		var db = 20 * log(float(volume[cursor_pos.x])/100) / log(10)
		db = clamp(db, -60, 0)
		AudioServer.set_bus_volume_db(audio_bus_indices[cursor_pos.x], db)
		cursor.get_node("Sound").play()

func _input(event):
#	if config_state == CONFIG.CONTROL:
	if discard_input:
		discard_input = false
	# Handle the first pressed key
	elif event is InputEventKey and not event.is_echo():
		# Register the event as handled and stop polling
		get_tree().set_input_as_handled()
		set_process_input(false)
		# Display the string corresponding to the pressed key
		var scancode = OS.get_scancode_string(event.scancode)
		node_list[cursor_pos.y][cursor_pos.x].text = scancode
		# Start by removing previously key binding(s)
		var action = input_actions[cursor_pos.y - 1]
		var old_keybind = keybinds[cursor_pos.y - 1][cursor_pos.x]
		if old_keybind in InputMap.get_action_list(action):
			InputMap.action_erase_event(action, old_keybind)
		# Add the new key binding
		InputMap.action_add_event(action, event)
#				save_to_config("input", action, scancode)
		config_state = CONFIG.NONE
		cursor.playing = true
		discard_input = true
