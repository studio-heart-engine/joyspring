extends Node2D

onready var solid_shader = preload('res://graphics/effects/solid_color.shader')
onready var outline_shader = preload('res://graphics/effects/outline-shader.shader')

var possible_colors = ['#306d78', '#205f74', '#3f3071', '#292767', '#3f3071', '#d0603d', '#de743d']

func update_shader(mode):
	if mode == 'normal':
		for child in $Blebs.get_children():
			get_node('Blebs/' + child.get_name() + '/Sprite').material.shader = null
			get_node('Blebs/' + child.get_name() + '/Outline').material.shader = outline_shader
			child.update_image()
		for child in $Blobs.get_children():
			get_node('Blobs/' + child.get_name() + '/NoiseOffset/Outline').material.shader = outline_shader
			get_node('Blobs/' + child.get_name() + '/NoiseOffset/Sprite').material.shader = null
		for child in $Joys.get_children():
			if child.is_following_player or child.is_on_cape:
				continue
			get_node('Joys/' + child.get_name() + '/Offset/AnimatedOutline/Sprite').material.shader = outline_shader
			get_node('Joys/' + child.get_name() + '/Offset/AnimatedOutline/Sprite').material.set_shader_param(
				'outline_color', Color(1, 1, 1, 1)
			)
			get_node('Joys/' + child.get_name() + '/Offset/Particles').material.shader = null
			get_node('Joys/' + child.get_name() + '/Offset/AnimatedSprite/Sprite').material.shader = null
		for child in $Gravel.get_children():
			get_node('Gravel/' + child.get_name() + '/Sprite').material.shader = null
			get_node('Gravel/' + child.get_name() + '/weak-rock-outline').material.shader = null
		for child in $MovingBlobs.get_children():
			get_node('MovingBlobs/' + child.get_name() + '/Path2D/PathFollow2D/Blob/NoiseOffset/Outline').material.shader = outline_shader
			get_node('MovingBlobs/' + child.get_name() + '/Path2D/PathFollow2D/Blob/NoiseOffset/Sprite').material.shader = null
		for child in $MovingPlatforms.get_children():
			get_node('MovingPlatforms/' + child.get_name() + '/Path2D/PathFollow2D/TextureTileMap').material.shader = null
		$TileMap.material.shader = null
		$TextureTileMap.material.shader = null
		$VineTileMap.material.shader = null
		$BlobTileMap.material.shader = null
		for child in $Environment.get_children():
			child.material.shader = null
		$Environment.modulate = Color(1, 1, 1, 1)
	if mode == 'solid':
		for child in $Blebs.get_children():
			get_node('Blebs/' + child.get_name() + '/Outline').material.shader = null
			get_node('Blebs/' + child.get_name() + '/Sprite').material.shader = solid_shader
			get_node('Blebs/' + child.get_name() + '/Sprite').material.set_shader_param(
				'color', Color(possible_colors[globals.bg_num - 1])
			)
		for child in $Blobs.get_children():
			get_node('Blobs/' + child.get_name() + '/NoiseOffset/Outline').material.shader = null
			get_node('Blobs/' + child.get_name() + '/NoiseOffset/Sprite').material.shader = solid_shader
			get_node('Blobs/' + child.get_name() + '/NoiseOffset/Sprite').material.set_shader_param(
				'color', Color(possible_colors[globals.bg_num - 1])
			)
		for child in $Joys.get_children():
			if child.is_following_player or child.is_on_cape:
				continue
			get_node('Joys/' + child.get_name() + '/Offset/AnimatedOutline/Sprite').material.shader = solid_shader
			get_node('Joys/' + child.get_name() + '/Offset/AnimatedOutline/Sprite').material.set_shader_param(
				'color', Color(possible_colors[globals.bg_num - 1])
			)
			get_node('Joys/' + child.get_name() + '/Offset/Particles').material.shader = solid_shader
			get_node('Joys/' + child.get_name() + '/Offset/Particles').material.set_shader_param(
				'color', Color(possible_colors[globals.bg_num - 1])
			)
			get_node('Joys/' + child.get_name() + '/Offset/AnimatedSprite/Sprite').material.shader = solid_shader
			get_node('Joys/' + child.get_name() + '/Offset/AnimatedSprite/Sprite').material.set_shader_param(
				'color', Color(possible_colors[globals.bg_num - 1])
			)
		for child in $Gravel.get_children():
			get_node('Gravel/' + child.get_name() + '/Sprite').material.shader = solid_shader
			get_node('Gravel/' + child.get_name() + '/Sprite').material.set_shader_param(
				'color', Color(possible_colors[globals.bg_num - 1])
			)
			get_node('Gravel/' + child.get_name() + '/weak-rock-outline').material.shader = solid_shader
			get_node('Gravel/' + child.get_name() + '/weak-rock-outline').material.set_shader_param(
				'color', Color(possible_colors[globals.bg_num - 1])
			)
		for child in $MovingBlobs.get_children():
			get_node('MovingBlobs/' + child.get_name() + '/Path2D/PathFollow2D/Blob/NoiseOffset/Outline').material.shader = null
			get_node('MovingBlobs/' + child.get_name() + '/Path2D/PathFollow2D/Blob/NoiseOffset/Sprite').material.shader = solid_shader
			get_node('MovingBlobs/' + child.get_name() + '/Path2D/PathFollow2D/Blob/NoiseOffset/Sprite').material.set_shader_param(
				'color', Color(possible_colors[globals.bg_num - 1])
			)
		for child in $MovingPlatforms.get_children():
			get_node('MovingPlatforms/' + child.get_name() + '/Path2D/PathFollow2D/TextureTileMap').material.shader = solid_shader
			get_node('MovingPlatforms/' + child.get_name() + '/Path2D/PathFollow2D/TextureTileMap').material.set_shader_param(
				'color', Color(possible_colors[globals.bg_num - 1])
			)
		$TileMap.material.shader = solid_shader
		$TileMap.material.set_shader_param('color', Color(possible_colors[globals.bg_num - 1]))
		$TextureTileMap.material.shader = solid_shader
		$TextureTileMap.material.set_shader_param('color', Color(possible_colors[globals.bg_num - 1]))
		$VineTileMap.material.shader = solid_shader
		$VineTileMap.material.set_shader_param('color', Color(possible_colors[globals.bg_num - 1]))
		$BlobTileMap.material.shader = solid_shader
		$BlobTileMap.material.set_shader_param('color', Color(possible_colors[globals.bg_num - 1]))
		for child in $Environment.get_children():
			child.material.shader = solid_shader
			child.material.set_shader_param(
				'color', Color(possible_colors[globals.bg_num - 1])
			)
		$Environment.modulate = Color(1, 1, 1, 0.8)

func get_collision_tile():
	var player = get_node("../Player")
	var tilemap = $TileMap
	var texturetilemap = $TextureTileMap
	var cell = tilemap.world_to_map(player.global_position + Vector2(0, 4))
	var tile_id = texturetilemap.get_cellv(cell)
	for platform in $MovingPlatforms.get_children():
		tilemap = get_node("MovingPlatforms/" + platform.get_name() + "/Path2D/PathFollow2D/TileMap")
		texturetilemap = get_node("MovingPlatforms/" + platform.get_name() + "/Path2D/PathFollow2D/TextureTileMap")
		var path = get_node("MovingPlatforms/" + platform.get_name() + "/Path2D/PathFollow2D")
		cell = tilemap.world_to_map(player.global_position - platform.position - path.position + Vector2(0, 4))
		if tile_id == -1:
			tile_id = texturetilemap.get_cellv(cell)
	return tile_id
