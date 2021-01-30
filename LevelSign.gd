extends Node2D

#export (Texture) var texture
var level_index = -1
export (bool) var locked setget set_locked, get_locked

var is_player_in_box = false


func set_locked(value):
	locked = not (level_index in globals.levels_completed or (level_index - 1) in globals.levels_completed)
#	modulate = Color(0.2, 0.2, 0.2) if locked else Color(1, 1, 1)

func get_locked():
	set_locked(-1)
	return locked

func _ready():
	self.locked = true
	level_index = int(name.right(9))


func _on_Hitbox_area_entered(area):
	set_locked(-1)
	if not locked:
		get_node('/root/HDWrapper/Text/Select' + str(level_index)).highlight()
	is_player_in_box = true


func _on_Hitbox_area_exited(area):
	set_locked(-1)
	if not locked:
		get_node('/root/HDWrapper/Text/Select' + str(level_index)).unhighlight()
	is_player_in_box = false


func _input(event):
	if is_player_in_box and event.is_action_pressed('ui_select'):
		set_locked(-1)
		if not locked:
			var level_path = 'platformer/levels/Level_' + '%02d' % level_index + '.tscn'
			SceneChanger.change_scene_to(load(level_path))
