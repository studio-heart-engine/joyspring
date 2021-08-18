
extends Node2D

#export (Texture) var texture
var level_index = -1
export (bool) var locked setget set_locked, get_locked
export (int) var out_layer

var selected = false

var rep_level

func set_locked(value):
	locked = not (level_index in globals.levels_completed or (level_index - 1) in globals.levels_completed)
#	modulate = Color(0.2, 0.2, 0.2) if locked else Color(1, 1, 1)

func get_locked():
	set_locked(-1)
	return locked

func _ready():
	return
	self.locked = true
	set_locked(-1)
	level_index = int(name.right(9))
	rep_level = load('res://platformer/levels/Level_' + ('%02d' % level_index) + '.tscn')
	if not self.locked:
		var rep_level_instance = rep_level.instance()
		var level_select = get_node('../../../LevelSelect')
		level_select.dash_enabled = level_select.dash_enabled or rep_level_instance.dash_enabled
		level_select.climb_enabled = level_select.climb_enabled or rep_level_instance.climb_enabled
		level_select.float_enabled = level_select.float_enabled or rep_level_instance.float_enabled
		rep_level_instance.queue_free()

func select():
	if not locked:
		get_node('/root/HDWrapper/Text/Select' + str(level_index)).highlight()
	selected = true

func deselect():
	if not locked:
		get_node('/root/HDWrapper/Text/Select' + str(level_index)).unhighlight()
	selected = false

func _input(event):
	if selected and event.is_action_pressed('dash'):
		set_locked(-1)
		if not locked:
			$Click.play()
			self.deselect()
			SceneChanger.change_scene_to(rep_level)
