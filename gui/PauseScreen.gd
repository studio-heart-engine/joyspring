extends CanvasLayer

var menu = 'main'

var keybinds
var buttons = {}

onready var control_container = $MarginContainer/VBoxContainer/Controls
onready var button_container = $MarginContainer/VBoxContainer/Buttons

onready var volume_label = $MarginContainer/VBoxContainer/Buttons/Column2/VBoxContainer/Volume/RichTextLabel

var margincontainer2_showed = false

func _ready():
	var button_script = load('res://gui/KeybindButton.gd')
	keybinds = globals.keybinds.duplicate()
	for key in keybinds.keys():
#		var hbox = HBoxContainer.new()
		var label = Label.new()
		var button = Button.new()
		
#		hbox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		
		label.text = key
		if keybinds[key] != null:
			button.text = OS.get_scancode_string(keybinds[key])
		else:
			button.text = 'Unassigned'
		
		button.set_script(button_script)
		button.key = key
		button.value = keybinds[key]
		button.menu = self
		button.toggle_mode = true
		button.focus_mode = Control.FOCUS_NONE
		
		var font = load('res://graphics/font.tres').duplicate()
		font.size = 40
		
		label.set('custom_fonts/font', font)
		label.align = Label.ALIGN_RIGHT
		
		button.flat = true
		button.set('custom_colors/font_color', Color(1, 1, 1, 1))
		button.set('custom_colors/font_color_hover', Color(0.28, 0.28, 0.28, 1))
		button.set('custom_colors/font_color_pressed', Color('ffce43'))
		button.set('custom_fonts/font', font)
		button.align = Button.ALIGN_LEFT
		

#		hbox.add_child(label)
#		hbox.add_child(button)
#		$MarginContainer/VBoxContainer/ControlMenu/ControlButtons.add_child(hbox)
		control_container.add_child(label)
		control_container.add_child(button)
#		$MarginContainer/VBoxContainer/ControlMenu.add_child(label)
#		$MarginContainer/VBoxContainer/ControlMenu.add_child(button)
		
		buttons[key] = button
	
	button_container.show()
	$MarginContainer/VBoxContainer/QuitButton.show()
	control_container.hide()
	$MarginContainer2.hide()
	$MarginContainer3.hide()
	$MarginContainer4.hide()
	
	$MarginContainer/VBoxContainer/Buttons/Column1/VBoxContainer/ResumeButton.focus_mode = Control.FOCUS_NONE
	$MarginContainer/VBoxContainer/Buttons/Column1/VBoxContainer/LevelSelectButton.focus_mode = Control.FOCUS_NONE
	$MarginContainer/VBoxContainer/Buttons/Column2/VBoxContainer/ControlsButton.focus_mode = Control.FOCUS_NONE
	$MarginContainer/VBoxContainer/Buttons/Column2/VBoxContainer/Volume/VolumeDownButton.focus_mode = Control.FOCUS_NONE
	$MarginContainer/VBoxContainer/Buttons/Column2/VBoxContainer/Volume/VolumeUpButton.focus_mode = Control.FOCUS_NONE
	$MarginContainer/VBoxContainer/QuitButton.focus_mode = Control.FOCUS_NONE
	$MarginContainer2/VBoxContainer/SettingsButton.focus_mode = Control.FOCUS_NONE
	$MarginContainer2/VBoxContainer/ControlsButton.focus_mode = Control.FOCUS_NONE

	volume_label.set_bbcode("[color=#ffce43]" + "Volume".left(globals.master_volume) + "[/color]" + "Volume".right(globals.master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(float(globals.master_volume) / 9))


func _process(delta):
	if Input.is_action_just_pressed('pause'):
		_on_SettingsButton_pressed()
	if globals.curr_state == 'Level_01' and not margincontainer2_showed and not get_tree().paused:
		margincontainer2_showed = true
		$MarginContainer2.show()
		$MarginContainer2/VBoxContainer/AnimationPlayer.play("show")
	elif globals.curr_state != 'Level_01' and margincontainer2_showed:
		$MarginContainer2.hide()
		margincontainer2_showed = false

func _on_SettingsButton_pressed():
	if get_tree().paused:
		if menu == 'main':
			resume()
		else:
			menu = 'main'
			button_container.show()
			$MarginContainer/VBoxContainer/QuitButton.show()
			control_container.hide()
			$MarginContainer2.hide()
			$MarginContainer3.show()
			$MarginContainer4.hide()
	else:
		pause()

func _on_ResumeButton_pressed():
	$Click.play()
	resume()
	# Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_LevelSelectButton_pressed():
	menu = 'select'
	$Click.play()
	if globals.curr_state.left(6) == 'Level_':
		cur_level = int(globals.curr_state.right(6))
		update_level()
	button_container.hide()
	$MarginContainer2.hide()
	$MarginContainer4.show()
	$MarginContainer/VBoxContainer/QuitButton.hide()

func _on_ControlsButton_pressed():
	$Click.play()
	menu = 'controls'
	button_container.hide()
	$MarginContainer/VBoxContainer/QuitButton.hide()
	$MarginContainer2.hide()
	control_container.show()
	$MarginContainer3.hide()
	$MarginContainer4.hide()
#	$MarginContainer/VBoxContainer/HBoxContainer.hide()
#	$MarginContainer/VBoxContainer/ControlMenu.show()

func _on_ControlsButton2_pressed():
	_on_SettingsButton_pressed()
	_on_ControlsButton_pressed()


func change_bind(key, value):
	$Tick.play()
	keybinds[key] = value
	for k in keybinds.keys():
		if k != key and value != null and keybinds[k] == value:
			if (key == 'dash' and k == 'float') or (key == 'float' and k == 'dash'):
				continue
			if (key == 'jump' and k == 'up') or (key == 'up' and k == 'jump'):
				continue
			keybinds[k] = null
			buttons[k].text = 'Unassigned'

	globals.keybinds = keybinds.duplicate()
	globals.set_controls()
	globals.save_controls()
	Events.emit_signal('keybind_changed')

#func _on_MenuButton_pressed():
#	$Click.play()
#	get_parent().emit_signal('level_exited')
#	PlayerData.score = 0
#	SceneChanger.change_scene_to(load("res://gui/Menu.tscn"))
#	yield($"/root/SceneChanger/AnimationPlayer", "animation_finished")
#	resume()

func pause():
	$MarginContainer.show()
	button_container.show()
	$MarginContainer3.show()
	$MarginContainer2.hide()
	$MarginContainer4.hide()
	$MarginContainer/VBoxContainer/QuitButton.show()
	get_tree().paused = true
	$MarginContainer/VBoxContainer/Buttons/Column2/VBoxContainer/ResetButton.text = 'Reset Data'
	$MarginContainer/VBoxContainer/Buttons/Column2/VBoxContainer/ResetButton.set('custom_colors/font_color', Color('ffffff'))
	# Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func resume():
	$MarginContainer.hide()
	$MarginContainer2.hide()
	$MarginContainer3.hide()
	$MarginContainer4.hide()
	get_tree().paused = false

func _on_QuitButton_pressed():
	$Click.play()
	globals.save_game()
	Events.emit_signal('quit_game')

# Reference: https://www.youtube.com/watch?v=I_Kzb-d-SvM


func _on_ResetButton_pressed():
	var button = $MarginContainer/VBoxContainer/Buttons/Column2/VBoxContainer/ResetButton
	if button.text == 'Reset Data':
		button.text = 'Click Again to Confirm'
		button.set('custom_colors/font_color', Color('ffce43'))
		return
	if button.text == 'Click Again to Confirm':
		$MarginContainer/VBoxContainer/Buttons/Column1/VBoxContainer/ResumeButton.hide()
		$MarginContainer/VBoxContainer/Buttons/Column2/VBoxContainer/ControlsButton.hide()
		$MarginContainer/VBoxContainer/Buttons/Column1/VBoxContainer/LevelSelectButton.hide()
		$MarginContainer/VBoxContainer/QuitButton.hide()
		button.disabled = true
		button.set('custom_colors/font_color', Color('ffffff'))
		var t = Timer.new()
		t.set_wait_time(1)
		t.set_one_shot(true)
		self.add_child(t)
		for i in range(3):
			button.text = 'Joyspring Will Quit Automatically in ' + str(3 - i) + ' second(s), \nPlease reopen'
			t.start()
			yield(t, 'timeout')
		
		globals.reset_game()

func _on_VolumeUpButton_pressed():
	$Tick.play()
	if globals.master_volume < 6:
		globals.master_volume += 1
	volume_label.set_bbcode("[color=#ffce43]" + "Volume".left(globals.master_volume) + "[/color]" + "Volume".right(globals.master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(float(globals.master_volume) / 6))


func _on_VolumeDownButton_pressed():
	$Tick.play()
	if globals.master_volume > 0:
		globals.master_volume -= 1
	volume_label.set_bbcode("[color=#ffce43]" + "Volume".left(globals.master_volume) + "[/color]" + "Volume".right(globals.master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(float(globals.master_volume) / 6))


var cur_level = 1

func _on_LevelDownButton_pressed():
	if not cur_level - 1 in globals.levels_completed:
		return
	if cur_level > 1:
		$Tick.play()
		cur_level -= 1
		update_level()

func _on_LevelUpButton_pressed():
	if not cur_level + 1 in globals.levels_completed and not cur_level in globals.levels_completed:
		return
	if cur_level < globals.total_levels:
		$Tick.play()
		cur_level += 1
		update_level()

func _on_LevelButton_pressed():
	menu = 'main'
	$Click.play()
	var level = load('res://platformer/levels/Level_' + ('%02d' % cur_level) + '.tscn')
	SceneChanger.change_scene_to(level)
	resume()

func update_level():
	$MarginContainer4/VBoxContainer/HBoxContainer/LevelButton.text = str(cur_level).pad_zeros(2)
	$MarginContainer4/VBoxContainer/HBoxContainer2/TextureRect.texture = load('res://platformer/levelSnapshots/level_' + str(cur_level) + '.png')
