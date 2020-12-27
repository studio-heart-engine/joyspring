extends Node2D

export (Texture) var texture
export (int) var level_index
export (bool) var locked setget set_locked

var is_player_in_box = false


func set_locked(value):
	locked = not (level_index in globals.levels_completed or level_index-1 in globals.levels_completed)
	modulate = Color(0.2, 0.2, 0.2) if locked else Color(1, 1, 1)


func _ready():
	self.locked = true
	$Sign.texture = texture
	$NumberLabel.text = str(level_index)


func _on_Hitbox_area_entered(area):
	is_player_in_box = true


func _on_Hitbox_area_exited(area):
	is_player_in_box = false


func _input(event):
	if is_player_in_box and event.is_action_pressed('ui_select') and not locked:
		var level_path = 'platformer/levels/Level_' + '%02d' % level_index + '.tscn'
		SceneChanger.change_scene(level_path)