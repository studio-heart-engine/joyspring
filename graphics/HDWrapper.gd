extends Node


onready var view_box = $ViewportContainer
onready var sub_viewport = $ViewportContainer/Viewport
onready var screen_res = get_viewport().size

onready var animation_player = $ViewportContainer/AnimationPlayer

var scaling = Vector2()
var show = []


func _ready():
	scaling = screen_res / sub_viewport.size
	view_box.rect_scale = scaling
	Events.connect('quit_game', self, 'quit_game')
	Events.connect('zoom_out', self, 'zoom_out')
	Events.connect('zoom_in', self, 'zoom_in')

func _process(delta):
#	print(Performance.get_monitor(Performance.TIME_FPS))
#	print(str(Performance.get_monitor(Performance.MEMORY_DYNAMIC)) + " " + str(Performance.get_monitor(Performance.MEMORY_STATIC)))
	scaling = screen_res / sub_viewport.size
	view_box.rect_scale = scaling
	if globals.curr_state.substr(0, 5) == 'Level' or globals.curr_state == 'Temp_End':
		set_level_text()
	else:
		hide_level_text()
	if globals.curr_state == 'LevelSelect':
		set_select_text()
	else:
		hide_select_text()
	if globals.curr_state.left(6) == 'Legend':
		set_legend_text()
	else:
		hide_legend_text()
	if globals.curr_state == 'End':
		set_title_text()
	else:
		if globals.curr_state != 'Level_12':
			pass
			hide_title_text()

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
			child.showed = false

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
				if not child. get_locked():
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

func set_legend_text():
	if sub_viewport.get_child(0):
		var path = "Text/Legend1"
		get_node(path).show()
		get_node(path).rect_position = Vector2(get_viewport().size.x / 2, get_viewport().size.y)
		get_node(path).rect_position.y -= 100
		get_node(path).rect_position.x -= get_node(path).rect_size.x / 2

func hide_legend_text():
	if sub_viewport.get_child(0):
		$Text/Legend1.hide()

func set_title_text():
	if sub_viewport.get_child(0):
		var title = get_node("Title")
		var tag
		
		if globals.curr_state == 'Level_12':
			title.rect_position = Vector2(get_viewport().size.x * 2 / 7, get_viewport().size.y / 2)
			tag = get_node("Text/Tag1")
		elif globals.curr_state == 'End':
			title.rect_position = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)
			tag = get_node("Text/Tag2")
			tag.rect_position = title.rect_position
		tag.rect_position = title.rect_position
		tag.rect_position.x -= $Text/Tag2/Label.rect_size.x / 2
		tag.rect_position.y += ($Title/Label.texture.get_height()) * $Title/Label.scale.y / 2
		title.show()
		tag.show()
		title.play()
		tag.play(false, 1.0)

func hide_title_text():
	if sub_viewport.get_child(0):
		if globals.curr_state == 'Level_12' or globals.curr_state == 'EndTransition':
			$Title.play(true)
			if globals.curr_state == 'Level_12':
				$Text/Tag1.play(true)
			elif globals.curr_state == 'EndTransition':
				$Text/Tag2.play(true)
		else:
			$Title.hide()

func clear_all():
	for child in $Text.get_children():
		child.hide()
	$Title/Sprite.hide()

func zoom_out():
	if sub_viewport.size != Vector2(640, 360):
		animation_player.play('zoom_out')

func zoom_in():
	animation_player.play('zoom_in')
	yield(animation_player, "animation_finished")
	globals.finished_peak_zoom = true

func quit_game():
	get_tree().quit()
