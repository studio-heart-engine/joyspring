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
var light_mask_vals

signal level_exited

var level_complete = false


func _ready():
	level_index = int(name.right(6))
	set_bg()
	Events.connect('bg_num_changed', self, 'set_bg')
	Events.connect('bg_num_changed', self, 'update_shader')
	Events.connect('swap_layers', self, 'swap_layers')
	
	for child in ($Layer0/Joys.get_children() + $Layer1/Joys.get_children()):
		if child.name in globals.joy_collected[level_index]:
			child.already_collected = true
			child.hide_light()
#			child.modulate = Color(0, 0, 0 ,1)
	
	layers = [$Layer0, $Layer1]
	collision_layer_vals = [1, pow(2, 5)]
	collision_mask_vals = [0, 0]
	for i in range(1, 5):
		collision_mask_vals[0] += pow(2, i)
	for i in range(6, 10):
		collision_mask_vals[1] += pow(2, i)
	
	light_mask_vals = [pow(2, 0), pow(2, 5)]
	
	layers[layer_num].z_index = 10
	layers[(layer_num + 1) % 2].z_index = -1
	layers[layer_num]._ready()
	layers[(layer_num + 1) % 2]._ready()
	update_shader()
	
	get_node('..').size = Vector2(400, 225)
	update_collision()
	update_light()

func _input(event):
	if event.is_action_pressed("swap"):
		swap_layers()
	if event.is_action_pressed("screenshot"):
		get_screenshot()


func swap_layers():
	layer_num = (layer_num + 1) % 2
	var layer_name = 'Layer' + str(layer_num)

	if check_collision(layer_name):
		layer_num = (layer_num + 1) % 2
		return
	else:
		update_collision()
		update_light()
		update_shader()
		$Swapper.play("swap_to_" + str(layer_num))
		$Swapper/SoundEffect.pitch_scale = 1 + rand_range(-0.1, 0.1)
		$Swapper/SoundEffect.play()
		Events.emit_signal("layer_swapped")
		pass

func check_collision(layer_name):
	var dir1 = Vector2(0, -4) # Bottom half of player
	var dir2 = Vector2(0, -12) # Top half of player
	
	var tile1 = layers[layer_num].get_collision_tile(dir1, 'TileMap')
	var tile2 = layers[layer_num].get_collision_tile(dir2, 'TileMap')
	return (tile1 != -1) or (tile2 != -1)

func update_collision():
	$Player.collision_layer = collision_layer_vals[layer_num]
	$Player.collision_mask = collision_mask_vals[layer_num]
	$Player/Hitbox.collision_layer = collision_layer_vals[layer_num]
	$Player/Hitbox.collision_mask = collision_layer_vals[layer_num]

func update_light():
	$Player/Light2D.range_item_cull_mask = light_mask_vals[layer_num]
	$Player/Light2D.shadow_item_cull_mask = light_mask_vals[layer_num]

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
	$ParallaxBackground/ParallaxLayer.motion_offset.x = 480
	$ParallaxBackground/ParallaxLayer.motion_offset.y = globals.bg_offset
	$ParallaxBackground/ParallaxLayer.motion_mirroring = Vector2(1024, 640)

func get_screenshot():
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.save_png("res://platformer/levelSnapshots/level_" + str(level_index) + ".png")
