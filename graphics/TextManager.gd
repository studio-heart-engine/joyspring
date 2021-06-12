extends Control

const text_scene = preload('res://graphics/Text.tscn')
const text_script = preload('res://graphics/Text.gd')

export var RADIUS = 36

func _ready():
	var story_dialogue_file = File.new()
	story_dialogue_file.open('res://story_dialogue.txt', File.READ)
	var i = 1
	while not story_dialogue_file.eof_reached():
		var line = story_dialogue_file.get_line()
		line = line.replace('\\n', '\n')
		print(line)
		var dialogue_text = text_scene.instance()
		dialogue_text.name = 'Dialogue' + str(i)
		dialogue_text.set_script(text_script)
		self.add_child(dialogue_text)
		get_node(dialogue_text.name + '/Label').text = line
		i += 1
	
	for j in range(1, globals.total_levels + 1):
		var select_text = text_scene.instance()
		select_text.name = 'Select' + str(j)
		select_text.set_script(text_script)
		self.add_child(select_text)

func check_dialogue(level, ids):
	var player = get_node("../ViewportContainer/Viewport/" + level + "/Player")
	for child in get_children():
		if child.get_name().substr(0, 8) != 'Dialogue' and child.get_name().substr(0, 8) != 'Tutorial':
			continue
		var id = child.get_name().right(8)
		if not (child.get_name().substr(0, 1) + id) in ids:  # Only play animation for dialogue in current level
			continue
		var text_pos
		var trigger_pos
		if child.get_name().substr(0, 8) == 'Dialogue':
			text_pos = get_node("../ViewportContainer/Viewport/" + level + "/Text" + id)
			trigger_pos = get_node("../ViewportContainer/Viewport/" + level + "/Text" + id + "/Pos")
		elif child.get_name().substr(0, 8) == 'Tutorial':
			text_pos = get_node("../ViewportContainer/Viewport/" + level + "/Tut" + id)
			trigger_pos = get_node("../ViewportContainer/Viewport/" + level + "/Tut" + id + "/Pos")
		
		if (trigger_pos.position + text_pos.position).distance_to(player.position) <= RADIUS:
			child.play()
