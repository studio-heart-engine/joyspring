extends Node2D

onready var outline_mat = preload('res://graphics/effects/outline_material.tres')
onready var solid_shader = preload('res://graphics/effects/solid_color.shader')
onready var outline_shader = preload('res://graphics/effects/outline-shader.shader')

var possible_colors = ['#225874', '3d203d', 'd2969b']

func update_shader(mode):
	if mode == 'normal':
		for child in $Blebs.get_children():
			get_node('Blebs/' + child.get_name() + '/Sprite').material.shader = outline_shader
			child.update_image()
		for child in $Blobs.get_children():
			get_node('Blobs/' + child.get_name() + '/NoiseOffset/Outline').material.shader = outline_shader
			get_node('Blobs/' + child.get_name() + '/NoiseOffset/Sprite').material.shader = null
		for child in $Joys.get_children():
			get_node('Joys/' + child.get_name() + '/Offset/Outline').material.shader = outline_shader
			get_node('Joys/' + child.get_name() + '/Offset/Particles').material.shader = null
			get_node('Joys/' + child.get_name() + '/Offset/AnimatedSprite/Sprite').material.shader = null
		for child in $Gravel.get_children():
			get_node('Gravel/' + child.get_name() + '/Sprite').material.shader = null
			get_node('Gravel/' + child.get_name() + '/weak-rock-outline').material.shader = null
		for child in $MovingBlobs.get_children():
			get_node('MovingBlobs/' + child.get_name() + '/Path2D/PathFollow2D/Blob/NoiseOffset/Outline').material.shader = outline_shader
			get_node('MovingBlobs/' + child.get_name() + '/Path2D/PathFollow2D/Blob/NoiseOffset/Sprite').material.shader = null
		for child in $MovingPlatforms.get_children():
			get_node('MovingPlatforms/' + child.get_name() + '/Path2D/PathFollow2D/TileMap').material.shader = null
		$TileMap.material.shader = null
		$VineTileMap.material.shader = null
		$BlobTileMap.material.shader = null
	if mode == 'solid':
		for child in $Blebs.get_children():
			get_node('Blebs/' + child.get_name() + '/Sprite').material.shader = solid_shader
			get_node('Blebs/' + child.get_name() + '/Sprite').material.set_shader_param(
				'color', Color(possible_colors[globals.time_of_day])
			)
		for child in $Blobs.get_children():
			get_node('Blobs/' + child.get_name() + '/NoiseOffset/Outline').material.shader = null
			get_node('Blobs/' + child.get_name() + '/NoiseOffset/Sprite').material.shader = solid_shader
			get_node('Blobs/' + child.get_name() + '/NoiseOffset/Sprite').material.set_shader_param(
				'color', Color(possible_colors[globals.time_of_day])
			)
		for child in $Joys.get_children():
			get_node('Joys/' + child.get_name() + '/Offset/Outline').material.shader = null
			get_node('Joys/' + child.get_name() + '/Offset/Particles').material.shader = solid_shader
			get_node('Joys/' + child.get_name() + '/Offset/Particles').material.set_shader_param(
				'color', Color(possible_colors[globals.time_of_day])
			)
			get_node('Joys/' + child.get_name() + '/Offset/AnimatedSprite/Sprite').material.shader = solid_shader
			get_node('Joys/' + child.get_name() + '/Offset/AnimatedSprite/Sprite').material.set_shader_param(
				'color', Color(possible_colors[globals.time_of_day])
			)
		for child in $Gravel.get_children():
			get_node('Gravel/' + child.get_name() + '/Sprite').material.shader = solid_shader
			get_node('Gravel/' + child.get_name() + '/Sprite').material.set_shader_param(
				'color', Color(possible_colors[globals.time_of_day])
			)
			get_node('Gravel/' + child.get_name() + '/weak-rock-outline').material.shader = solid_shader
			get_node('Gravel/' + child.get_name() + '/weak-rock-outline').material.set_shader_param(
				'color', Color(possible_colors[globals.time_of_day])
			)
		for child in $MovingBlobs.get_children():
			get_node('MovingBlobs/' + child.get_name() + '/Path2D/PathFollow2D/Blob/NoiseOffset/Outline').material.shader = null
			get_node('MovingBlobs/' + child.get_name() + '/Path2D/PathFollow2D/Blob/NoiseOffset/Sprite').material.shader = solid_shader
			get_node('MovingBlobs/' + child.get_name() + '/Path2D/PathFollow2D/Blob/NoiseOffset/Sprite').material.set_shader_param(
				'color', Color(possible_colors[globals.time_of_day])
			)
		for child in $MovingPlatforms.get_children():
			get_node('MovingPlatforms/' + child.get_name() + '/Path2D/PathFollow2D/TileMap').material.shader = solid_shader
			get_node('MovingPlatforms/' + child.get_name() + '/Path2D/PathFollow2D/TileMap').material.set_shader_param(
				'color', Color(possible_colors[globals.time_of_day])
			)
		$TileMap.material.shader = solid_shader
		$TileMap.material.set_shader_param('color', Color(possible_colors[globals.time_of_day]))
		$VineTileMap.material.shader = solid_shader
		$VineTileMap.material.set_shader_param('color', Color(possible_colors[globals.time_of_day]))
		$BlobTileMap.material.shader = solid_shader
		$BlobTileMap.material.set_shader_param('color', Color(possible_colors[globals.time_of_day]))
