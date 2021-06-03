extends Node2D

export (PackedScene) var next_level
export (bool) var dash_enabled = true
export (bool) var float_enabled = true
export (bool) var climb_enabled = true
var level_index setget , get_level_index

var layers
var layer_names = ['Layer0', 'Layer1']
var layer_num = 0
var collision_layer_vals
var collision_mask_vals

onready var outline_mat = preload('res://graphics/effects/outline_material.tres')
onready var solid_shader = preload('res://graphics/effects/solid_color.shader')
onready var outline_shader = preload('res://graphics/effects/outline-shader.shader')

signal level_exited


func _ready():
	level_index = int(name.right(6))
	if globals.curr_state == 'LevelSelect':
		if globals.prev_state.substr(0, 5) == 'Level' and globals.prev_state != 'LevelSelect':
			$Player.position = get_node('LevelSign' + str(int(globals.prev_state.right(5)))).position
	set_bg()
	
	layers = [$Layer0, $Layer1]
	
	collision_layer_vals = [1, pow(2, 5)]
	collision_mask_vals = [0, 0]
	for i in range(1, 5):
		collision_mask_vals[0] += pow(2, i)
	for i in range(6, 10):
		collision_mask_vals[1] += pow(2, i)
	update_collision()
	
#	layers[layer_num].modulate = Color(1, 1, 1)
	layers[layer_num].z_index = 10
#	layers[(layer_num + 1) % 2].modulate = Color(0, 0, 0)
	layers[(layer_num + 1) % 2].z_index = 0
	
	layers[layer_num]._ready()
	layers[(layer_num + 1) % 2]._ready()
	update_shader()


func _input(event):
	if event.is_action_pressed("swap"):
		layer_num = (layer_num + 1) % 2
		
		# Check if player is inside tile
		var dummy = get_node('Layer' + str(layer_num) + '/Dummy')
		dummy.position = $Player.position
		if dummy.move_and_collide(Vector2(0, 0)):
			layer_num = (layer_num + 1) % 2
			return
		else:
			update_collision()
			$Swapper.play("swap_to_" + str(layer_num))
			update_shader()
			
			Events.emit_signal("layer_swapped")


func update_collision():
	$Player.collision_layer = collision_layer_vals[layer_num]
	$Player.collision_mask = collision_mask_vals[layer_num]
	$Player/Hitbox.collision_layer = $Player.collision_layer
	$Player/Hitbox.collision_mask = $Player.collision_mask


func update_shader():
	layers[layer_num].update_shader('normal')
	layers[(layer_num + 1) % 2].update_shader('solid')


func all_joys_collected():
	return $Joys.get_child_count() == 0


func get_level_index():
	return level_index


func _on_ExitArea_area_entered(area):
	SceneChanger.change_scene_to(load('res://gui/Menu.tscn'))


func set_bg():
	var image_path = "res://graphics/environment/background" + str(globals.bg_num) + ".png"
	$ParallaxBackground/ParallaxLayer/background.set_texture(load(image_path))
	$ParallaxBackground/ParallaxLayer.motion_offset.y = globals.bg_offset
