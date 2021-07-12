extends Node


onready var view_box = $ViewportContainer
onready var sub_viewport = $ViewportContainer/Viewport
onready var screen_res = get_viewport().size

var scaling = Vector2()
var show = []


func _ready():
	scaling = screen_res / sub_viewport.size
	view_box.rect_scale = scaling
	Events.connect('quit_game', self, 'quit_game')

func _process(delta):
#	print(Performance.get_monitor(Performance.TIME_FPS))
#	print(str(Performance.get_monitor(Performance.MEMORY_DYNAMIC)) + " " + str(Performance.get_monitor(Performance.MEMORY_STATIC)))
	if globals.curr_state.substr(0, 5) == 'Level' or globals.curr_state == 'Temp_End':
		set_level_text()
	else:
		hide_level_text()
	if globals.curr_state == 'LevelSelect':
		set_select_text()
	else:
		hide_select_text()
	if globals.curr_state == 'Opening':
		set_opening_text()
	else:
		hide_opening_text()
	if globals.curr_state == 'Menu':
		set_menu_text()
	else:
		hide_menu_text()

func set_level_text():
	show = []
	if sub_viewport.get_child(0):
		var children = sub_viewport.get_child(0).get_children()
		for child in children:
			if child.name.substr(0, 4) == "Text":
				var coord = child.get_global_transform_with_canvas().origin
				var path = "Text/Dialogue" + child.name.right(4)
				get_node(path).rect_position = coord * scaling
				show.append('D' + child.get_name().right(4))
			if child.name.substr(0, 3) == "Tut":
				var path = "Text/Tutorial" + child.name.right(3)
				get_node(path).rect_position = Vector2(get_viewport().size.x / 2, get_viewport().size.y)
				get_node(path).rect_position.y -= 100 + (get_node(path + "/Label").rect_size.y - 72)
				get_node(path).rect_position.x -= get_node(path + "/Label").rect_size.x / 2
				show.append('T' + child.get_name().right(3))
		for child in $Text.get_children():
			if child.get_name().substr(0, 8) != 'Dialogue' and child.get_name().substr(0, 8) != 'Tutorial':
				continue
			if (child.get_name().substr(0, 1) + child.get_name().right(8)) in show:
				child.show()
			else:
				child.hide()
		$Text.check_dialogue(sub_viewport.get_child(0).get_name(), show)

func hide_level_text():
	for child in $Text.get_children():
		if child.get_name().substr(0, 8) == 'Dialogue' or child.get_name().substr(0, 8) == 'Tutorial':
			child.hide()

func set_select_text():
	show = []
	if sub_viewport.get_child(0):
		if sub_viewport.get_child(0).get_name() != 'LevelSelect':
			return
		var children = $ViewportContainer/Viewport/LevelSelect/LevelSigns.get_children()
		for child in children:
			if child.name.substr(0, 9) == "LevelSign":
				var coord = child.get_node("Number").get_global_transform_with_canvas().origin
				var path = "Text/Select" + child.name.right(9)
				get_node(path).rect_position = coord * scaling
				get_node(path).rect_position -= Vector2(get_node(path + '/TextureRect').rect_size.x / 2, 0)  # Center align
				if not child.get_locked():
					show.append('S' + child.get_name().right(9))
		for child in $Text.get_children():
			if child.get_name().substr(0, 6) != 'Select':
				continue
			if (child.get_name().substr(0, 1) + child.get_name().right(6)) in show:
				child.show()
			else:
				child.hide()

func hide_select_text():
	for child in $Text.get_children():
		if child.name.substr(0, 6) == "Select":
			child.hide()

func set_opening_text():
	if sub_viewport.get_child(0):
		var path = "Text/Legend1"
		get_node(path).show()
		get_node(path).rect_position = Vector2(get_viewport().size.x / 2, get_viewport().size.y)
		get_node(path).rect_position.y -= 100
		get_node(path).rect_position.x -= get_node(path).rect_size.x / 2

func hide_opening_text():
	if sub_viewport.get_child(0):
		$Text/Legend1.hide()

func set_menu_text():  # Including title image
	if sub_viewport.get_child(0):
		var path1 = "Text/Menu1"
		var path2 = "Title"
		get_node(path1).show()
		get_node(path2).show()
		get_node(path1).rect_position = Vector2(get_viewport().size.x / 2, get_viewport().size.y)
		get_node(path1).rect_position.y -= 100 + (get_node(path1 + "/Label").rect_size.y - 72)
		get_node(path1).rect_position.x -= get_node(path1 + "/Label").rect_size.x / 2
		get_node(path1).play()
		
		get_node(path2).rect_position = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)
		get_node(path2).play()

func hide_menu_text():
	if sub_viewport.get_child(0):
		var path1 = "Text/Menu1"
		var path2 = "Title/Sprite"
		get_node(path1).hide()
		if globals.curr_state == 'MenuTransition':
			$Title.play(true)
		else:
			$Title.hide()

func clear_all():
	for child in $Text.get_children():
		child.hide()
	$Title/Sprite.hide()
	

func quit_game():
	get_tree().quit()
