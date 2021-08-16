extends Node2D

onready var solid_shader = preload('res://graphics/effects/solid_color.shader')
onready var outline_shader = preload('res://graphics/effects/outline-shader.shader')

var possible_colors = ['#306d78', '#205f74', '#2e3d67', '#222b4f', '#29355b', '#b74730', '#c95036']

func update_shader(mode):
	if mode == 'normal':
		for child in $Blebs.get_children():
			get_node('Blebs/' + child.get_name() + '/Sprite').material.shader = null
			get_node('Blebs/' + child.get_name() + '/Outline').material.shader = outline_shader
			child.update_image()
		for child in $Blobs.get_children():
			if child.get_name().substr(0, 8) == 'BlobPath':
				continue
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
			get_node('Joys/' + child.get_name() + '/Offset/Light2D').energy = 0.6
		for child in $Gravel.get_children():
			get_node('Gravel/' + child.get_name() + '/Sprite').material.shader = null
			get_node('Gravel/' + child.get_name() + '/weak-rock-outline').show()
		for child in $MovingBlobs.get_children():
			get_node('MovingBlobs/' + child.get_name() + '/Path2D/PathFollow2D/Blob/NoiseOffset/Outline').material.shader = outline_shader
			get_node('MovingBlobs/' + child.get_name() + '/Path2D/PathFollow2D/Blob/NoiseOffset/Sprite').material.shader = null
			get_node('MovingBlobs/' + child.get_name() + '/Dots').show()
		for child in $MovingPlatforms.get_children():
			get_node('MovingPlatforms/' + child.get_name() + '/Path2D/PathFollow2D/TextureTileMap').material.shader = null
			get_node('MovingPlatforms/' + child.get_name() + '/Dots').show()
		$TileMap.material.shader = null
		$TextureTileMap.material.shader = null
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
			if child.get_name().substr(0, 8) == 'BlobPath':
				continue
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
			get_node('Joys/' + child.get_name() + '/Offset/Light2D').energy = 0.2
		for child in $Gravel.get_children():
			get_node('Gravel/' + child.get_name() + '/Sprite').material.shader = solid_shader
			get_node('Gravel/' + child.get_name() + '/Sprite').material.set_shader_param(
				'color', Color(possible_colors[globals.bg_num - 1])
			)
			get_node('Gravel/' + child.get_name() + '/weak-rock-outline').hide()
		for child in $MovingBlobs.get_children():
			get_node('MovingBlobs/' + child.get_name() + '/Path2D/PathFollow2D/Blob/NoiseOffset/Outline').material.shader = null
			get_node('MovingBlobs/' + child.get_name() + '/Path2D/PathFollow2D/Blob/NoiseOffset/Sprite').material.shader = solid_shader
			get_node('MovingBlobs/' + child.get_name() + '/Path2D/PathFollow2D/Blob/NoiseOffset/Sprite').material.set_shader_param(
				'color', Color(possible_colors[globals.bg_num - 1])
			)
			get_node('MovingBlobs/' + child.get_name() + '/Dots').hide()
		for child in $MovingPlatforms.get_children():
			get_node('MovingPlatforms/' + child.get_name() + '/Path2D/PathFollow2D/TextureTileMap').material.shader = solid_shader
			get_node('MovingPlatforms/' + child.get_name() + '/Path2D/PathFollow2D/TextureTileMap').material.set_shader_param(
				'color', Color(possible_colors[globals.bg_num - 1])
			)
			get_node('MovingPlatforms/' + child.get_name() + '/Dots').hide()
		$TileMap.material.shader = solid_shader
		$TileMap.material.set_shader_param('color', Color(possible_colors[globals.bg_num - 1]))
		$TextureTileMap.material.shader = solid_shader
		$TextureTileMap.material.set_shader_param('color', Color(possible_colors[globals.bg_num - 1]))
		$BlobTileMap.material.shader = solid_shader
		$BlobTileMap.material.set_shader_param('color', Color(possible_colors[globals.bg_num - 1]))
		for child in $Environment.get_children():
			child.material.shader = solid_shader
			child.material.set_shader_param(
				'color', Color(possible_colors[globals.bg_num - 1])
			)
		$Environment.modulate = Color(1, 1, 1, 0.8)


func get_collision_tile(dir, collision_on='TextureTileMap'):
	var player = get_node("../Player")
	var tilemap = $TileMap
	var texturetilemap = $TextureTileMap
	var collision_tilemap = texturetilemap if collision_on == 'TextureTileMap' else tilemap
	var cell = tilemap.world_to_map(player.global_position + dir)
	var tile_id = collision_tilemap.get_cellv(cell)
#	var tile_id = texturetilemap.get_cellv(cell)
	for platform in $MovingPlatforms.get_children():
		tilemap = get_node("MovingPlatforms/" + platform.get_name() + "/Path2D/PathFollow2D/TileMap")
		texturetilemap = get_node("MovingPlatforms/" + platform.get_name() + "/Path2D/PathFollow2D/TextureTileMap")
		collision_tilemap = texturetilemap if collision_on == 'TextureTileMap' else tilemap
		var path = get_node("MovingPlatforms/" + platform.get_name() + "/Path2D/PathFollow2D")
		cell = tilemap.world_to_map(player.global_position - platform.position - path.position + dir)
		if tile_id == -1:
			tile_id = collision_tilemap.get_cellv(cell)
#			tile_id = texturetilemap.get_cellv(cell)
	return tile_id
