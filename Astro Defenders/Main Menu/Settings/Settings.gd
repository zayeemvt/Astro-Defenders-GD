extends Node2D

enum SETTINGS { AUDIO, UP, DOWN, LEFT, RIGHT, SHOOT, BACK }
enum CONFIG { AUDIO, CONTROL, NONE }

const SETTINGS_FILE = "user://settings.cfg"

@onready var node_list = [ [$"Options/Audio/Music", $"Options/Audio/Sound"], 
						  [$"Options/Up/Key1", $"Options/Up/Key2"], 
						  [$"Options/Down/Key1", $"Options/Down/Key2"], 
						  [$"Options/Left/Key1", $"Options/Left/Key2"], 
						  [$"Options/Right/Key1", $"Options/Right/Key2"], 
						  [$"Options/Shoot/Key1", $"Options/Shoot/Key2"], 
						  [$"Options/Back/Action", $"Options/Back/Action"]]
@onready var cursor = $"Menu Cursor"

@onready var x_offset = int(cursor.sprite_frames.get_frame_texture("default", 0).get_size().x / 2)
@onready var y_offset = int(node_list[0][0].size.y / 2)

@onready var audio_bus_indices = [AudioServer.get_bus_index("Music"), AudioServer.get_bus_index("Sound")]

const input_actions = [ "player_up", "player_down", "player_left", "player_right", "player_shoot"]

var cursor_pos = {"x" : 0, "y" : 0}
var config_state = CONFIG.NONE
var discard_input = false

var volume = [] # ints
var keybinds = [] # InputEvents as 2D array

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(false) # only reactivate when remapping keybinds
	
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_FILE)
	if err: # Assuming that file is missing, generate default config
		# Set audio settings
		volume = [100, 100]
		config.set_value("audio", "Music", 100)
		config.set_value("audio", "Sound", 100)
		
		# Set keybindings
		for action in input_actions:
			keybinds.append(InputMap.action_get_events(action))
			
			# Convert to cfg-ready format
			var action_list = []
			for key in InputMap.action_get_events(action):
				# Save keybind as scancode string
				action_list.append(OS.get_keycode_string(key.keycode))
			
			config.set_value("input", action, action_list)
		config.save(SETTINGS_FILE)
	
	else: # Config file exists
		# Load audio settings
		volume = [config.get_value("audio", "Music"), config.get_value("audio", "Sound")]
		for i in range (node_list[0].size()):
			node_list[0][i].get_node("Volume").text = str(volume[i]) + "%"
		
		# Load keybinds
		var i = 1
		var j = 0
		for action in config.get_section_keys("input"):
			# Delete old keybinds
			for old_event in InputMap.action_get_events(action):
				InputMap.action_erase_event(action, old_event)
			
			var inputs = []
			for key in config.get_value("input", action):
				# Get the key scancode corresponding to the saved human-readable string
				var keycode = OS.find_keycode_from_string(key)
				# Create a new event object based on the saved scancode
				var event = InputEventKey.new()
				event.keycode = keycode
				InputMap.action_add_event(action, event)
				
				inputs.append(event)
				
				node_list[i][j].text = key
				j += 1
			
			keybinds.append(inputs)
			
			i += 1
			j = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match config_state:
		CONFIG.NONE:
			move_cursor()
		CONFIG.AUDIO:
			adjust_audio(node_list[cursor_pos.y][cursor_pos.x])
		CONFIG.CONTROL:
			pass # wait for input


func save_to_config(section, key, value):
	"""Helper function to redefine a parameter in the settings file"""
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_FILE)
	if err:
		print("Error code when loading config file: ", err)
	else:
		config.set_value(section, key, value)
		config.save(SETTINGS_FILE)


func highlight(node):
	$"Menu Cursor".position.x = (node.get_parent().position.x + node.position.x) - x_offset
	$"Menu Cursor".position.y = node.get_parent().position.y + y_offset


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
		get_tree().change_scene_to_file("res://Main Menu/Main Menu.tscn")
	else:
		cursor.stop()
		
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
		save_to_config("audio", "Music", volume[0])
		save_to_config("audio", "Sound", volume[1])
		config_state = CONFIG.NONE
		cursor.play("default")
		var db = 20 * log(float(volume[cursor_pos.x])/100) / log(10)
		db = clamp(db, -60, 0)
		AudioServer.set_bus_volume_db(audio_bus_indices[cursor_pos.x], db)
		cursor.get_node("Sound").play()

# For control remapping
func _input(event):
#	if config_state == CONFIG.CONTROL:

	# Prevent the "player_shoot" action from being registered
	# as the input
	if discard_input:
		discard_input = false
		
	# Otherwise, handle the first pressed key
	elif event is InputEventKey and not event.is_echo():
		# Register the event as handled and stop polling
		get_viewport().set_input_as_handled()
		set_process_input(false)
		
		# Display the string corresponding to the pressed key
		var keycode = OS.get_keycode_string(event.keycode)
		node_list[cursor_pos.y][cursor_pos.x].text = keycode
		
		# Start by removing previously key binding(s)
		var action = input_actions[cursor_pos.y - 1]
		var old_keybind = keybinds[cursor_pos.y - 1][cursor_pos.x]
		if old_keybind in InputMap.action_get_events(action):
			InputMap.action_erase_event(action, old_keybind)
			
		# Add the new key binding
		InputMap.action_add_event(action, event)
		keybinds[cursor_pos.y - 1][cursor_pos.x] = event
		
		var inputs = []
		for key in keybinds[cursor_pos.y - 1]:
			inputs.append(OS.get_keycode_string(key.keycode))
		
		save_to_config("input", action, inputs)
		config_state = CONFIG.NONE
		cursor.play("default")
		discard_input = true
