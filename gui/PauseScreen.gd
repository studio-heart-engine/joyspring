extends CanvasLayer

var menu = 'main'

var keybinds
var buttons = {}

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
		$MarginContainer/VBoxContainer/ControlMenu.add_child(label)
		$MarginContainer/VBoxContainer/ControlMenu.add_child(button)
		
		buttons[key] = button
	
	$MarginContainer/VBoxContainer/Buttons.show()
	$MarginContainer/VBoxContainer/ControlMenu.hide()

func _process(delta):
	if Input.is_action_just_pressed('pause'):
		if get_tree().paused:
			if menu == 'main':
				resume()
			else:
				menu = 'main'
				$MarginContainer/VBoxContainer/Buttons.show()
				$MarginContainer/VBoxContainer/ControlMenu.hide()
		else:
			pause()


func _on_ResumeButton_pressed():
	$Click.play()
	resume()
	# Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_LevelSelectButton_pressed():
	$Click.play()
	if get_parent().name.substr(0, 5) == 'Level':
		get_parent().emit_signal('level_exited')
	PlayerData.score = 0
	SceneChanger.change_scene_to(load("res://gui/LevelSelect.tscn"))
	yield($"/root/SceneChanger/AnimationPlayer", "animation_finished")
	resume()

func _on_ControlsButton_pressed():
	menu = 'controls'
	$MarginContainer/VBoxContainer/Buttons.hide()
	$MarginContainer/VBoxContainer/ControlMenu.show()


func change_bind(key, value):
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
	get_tree().paused = true
	$MarginContainer/VBoxContainer/Buttons/ResetButton.text = 'Reset Data'
	$MarginContainer/VBoxContainer/Buttons/ResetButton.set('custom_colors/font_color', Color('ffffff'))
	# Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func resume():
	$MarginContainer.hide()
	get_tree().paused = false

func _on_QuitButton_pressed():
	Events.emit_signal('quit_game')

# Reference: https://www.youtube.com/watch?v=I_Kzb-d-SvM


func _on_ResetButton_pressed():
	var button = $MarginContainer/VBoxContainer/Buttons/ResetButton
	if button.text == 'Reset Data':
		button.text = 'Click Again to Confirm'
		button.set('custom_colors/font_color', Color('ffce43'))
		return
	if button.text == 'Click Again to Confirm':
		$MarginContainer/VBoxContainer/Buttons/ResumeButton.hide()
		$MarginContainer/VBoxContainer/Buttons/ControlsButton.hide()
		$MarginContainer/VBoxContainer/Buttons/LevelSelectButton.hide()
		$MarginContainer/VBoxContainer/Buttons/QuitButton.hide()
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
