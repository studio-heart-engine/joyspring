extends Control

const text_scene = preload('res://graphics/Text.tscn')
const text_script = preload('res://graphics/Text.gd')
const tutorial_script = preload('res://graphics/TutorialText.gd')

export var RADIUS = 36

var text_set = false

func _ready():
	if text_set:
		return
	# Load legend
	var legend_file = File.new()
	legend_file.open('res://text/legend.txt', File.READ)
	$Legend1.text = legend_file.get_as_text().replace('’', '\'')
	legend_file.close()
	
	# Load dialogue
	var dialogue_file = File.new()
	dialogue_file.open('res://text/dialogue.txt', File.READ)
	var i = 1
	while not dialogue_file.eof_reached():
		var line = dialogue_file.get_line()
		line = line.replace('\\n', '\n')
		line = line.replace('’', '\'')
		var dialogue_text = text_scene.instance()
		dialogue_text.name = 'Dialogue' + str(i)
		dialogue_text.set_script(text_script)
		self.add_child(dialogue_text)
		get_node(dialogue_text.name + '/Label').text = line
		i += 1
	dialogue_file.close()

	# Load tutorial
	var tutorial_file = File.new()
	tutorial_file.open('res://text/tutorial.txt', File.READ)
	var j = 1
	while not tutorial_file.eof_reached():
		var type = tutorial_file.get_line()
		var line = tutorial_file.get_line()
		line = line.replace('\\n', '\n')
		line = line.replace('’', '\'')
		var tutorial_text = text_scene.instance()
		tutorial_text.name = 'Tutorial' + str(j)
		tutorial_text.set_script(text_script)
		self.add_child(tutorial_text)
		get_node(tutorial_text.name + '/Label').text = line
		get_node(tutorial_text.name + '/Label').align = HALIGN_CENTER
		get_node(tutorial_text.name + '/Label').set_script(tutorial_script)
		get_node(tutorial_text.name + '/Label').action = type
		get_node(tutorial_text.name + '/Label')._ready()
		j += 1
	tutorial_file.close()

	# Load select
	for k in range(1, globals.total_levels + 1):
		var select_text = text_scene.instance()
		select_text.name = 'Select' + str(k)
		select_text.set_script(text_script)
		self.add_child(select_text)
	
	text_set = true

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
