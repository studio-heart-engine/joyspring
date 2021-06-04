extends CanvasLayer

var menu = 'main'

var keybinds
var buttons = {}

func _ready():
	var button_script = load('res://gui/KeybindButton.gd')
	keybinds = globals.keybinds.duplicate()
	for key in keybinds.keys():
		var hbox = HBoxContainer.new()
		var label = Label.new()
		var button = Button.new()
		
		hbox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
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
		label.align = Label.ALIGN_CENTER
		
		button.flat = true
		button.set('custom_colors/font_color', Color(1, 1, 1, 1))
		button.set('custom_colors/font_color_hover', Color(0.28, 0.28, 0.28, 1))
		button.set('custom_colors/font_color_pressed', Color('ffce43'))
		button.set('custom_fonts/font', font)
		
		
		hbox.add_child(label)
		hbox.add_child(button)
		$MarginContainer/VBoxContainer/ControlMenu/ControlButtons.add_child(hbox)
		
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
			keybinds[k] = null
			buttons[k].text = 'Unassigned'

	globals.keybinds = keybinds.duplicate()
	globals.set_controls()
	globals.save_controls()

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
	# Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func resume():
	$MarginContainer.hide()
	get_tree().paused = false

func _on_QuitButton_pressed():
	get_tree().quit()

# Reference: https://www.youtube.com/watch?v=I_Kzb-d-SvM
