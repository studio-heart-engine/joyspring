extends Node2D

#export (PackedScene) var next_level
export (bool) var dash_enabled = true
export (bool) var float_enabled = true
export (bool) var climb_enabled = true
var level_index setget , get_level_index

var layers
var layer_num = 0
var collision_layer_vals
var collision_mask_vals

onready var outline_mat = preload('res://graphics/effects/outline_material.tres')
onready var solid_shader = preload('res://graphics/effects/solid_color.shader')
onready var outline_shader = preload('res://graphics/effects/outline-shader.shader')

signal level_exited


func _ready():
	level_index = int(name.right(6))
	set_bg()
	Events.connect('bg_num_changed', self, 'set_bg')
	Events.connect('bg_num_changed', self, 'update_shader')
	Events.connect('swap_layers', self, 'swap_layers')
	
	if globals.curr_state == 'LevelSelect':
		if globals.prev_state.substr(0, 5) == 'Level' and globals.prev_state != 'LevelSelect':
			$Player.position = get_node('LevelSigns/LevelSign' + str(int(globals.prev_state.right(5)))).position
			layer_num = get_node('LevelSigns/LevelSign' + str(int(globals.prev_state.right(5)))).out_layer
	
	for child in ($Layer0/Joys.get_children() + $Layer1/Joys.get_children()):
		if child.name in globals.joy_collected[level_index]:
			child.already_collected = true
#			child.modulate = Color(0, 0, 0 ,1)
	
	layers = [$Layer0, $Layer1]
	collision_layer_vals = [1, pow(2, 5)]
	collision_mask_vals = [0, 0]
	for i in range(1, 5):
		collision_mask_vals[0] += pow(2, i)
	for i in range(6, 10):
		collision_mask_vals[1] += pow(2, i)
	update_collision()
	update_occlusion()
	
	layers[layer_num].z_index = 10
	layers[(layer_num + 1) % 2].z_index = 0
	layers[layer_num]._ready()
	layers[(layer_num + 1) % 2]._ready()
	update_shader()
	
	if globals.curr_state == 'LevelSelect':
		$Switch._ready()
		$Tut0.position = $Player.position


func _input(event):
	if event.is_action_pressed("swap"):
		swap_layers()


func swap_layers():
	layer_num = (layer_num + 1) % 2
	var layer_name = 'Layer' + str(layer_num)

	if check_collision(layer_name):
		layer_num = (layer_num + 1) % 2
		return
	else:
		update_collision()
		update_occlusion()
		$Swapper.play("swap_to_" + str(layer_num))
		update_shader()
		Events.emit_signal("layer_swapped")

func check_collision(layer_name):  # Check if player is inside tilemap
	var index1 = get_node(layer_name + '/TileMap').world_to_map($Player.position)  # Bottom half of player
	var index2 = get_node(layer_name + '/TileMap').world_to_map($Player.position + Vector2(0, -8))  # Top half of player
	var inside_tile = get_node(layer_name + '/TileMap').get_cellv(index1) != -1 or \
					  get_node(layer_name + '/TileMap').get_cellv(index2) != -1
	return inside_tile

func update_collision():
	$Player.collision_layer = collision_layer_vals[layer_num]
	$Player.collision_mask = collision_mask_vals[layer_num]
	$Player/Hitbox.collision_layer = $Player.collision_layer
	$Player/Hitbox.collision_mask = $Player.collision_mask


func update_occlusion():
	get_node('Layer' + str(layer_num) + '/TileMap').light_mask = 1
	get_node('Layer' + str((layer_num + 1) % 2) + '/TileMap').light_mask = 0


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
