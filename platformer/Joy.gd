extends Node2D

var POINTS_PER_COIN = 10
var is_following_player = false setget set_following_player
var is_on_cape = false setget set_on_cape
var already_collected = false

onready var anim_player = $Offset/AnimatedSprite/AnimationPlayer
onready var outline_anim_player = $Offset/AnimatedOutline/AnimationPlayer

onready var outline_shader = preload('res://graphics/effects/outline-shader.shader')

var TIME_OF_DAY = ['evening', 'midnight', 'dawn']
var texture_theme = 'normal'

func get_time_of_day():
	return TIME_OF_DAY[globals.time_of_day]

func fade_out():
	$Offset/Particles.emitting = true
	anim_player.play("fade_out")
	outline_anim_player.play('fade_out')
	yield(anim_player, "animation_finished")
	$Offset/Particles.emitting = false
	call_deferred("free")


func _ready():
	rotation_degrees = randi() % 2 * 180
	anim_player.get_animation("collect1").set_loop(false)
	var rand_advance = rand_range(0, anim_player.get_animation(anim_player.current_animation).length)
	anim_player.advance(rand_advance)
	outline_anim_player.advance(rand_advance)
	if self.name.substr(0, 4) == 'Swap':
		set_theme_texture()

#	$Offset/Outline.set_material($Offset/Outline.get_material().duplicate())
	$Offset/AnimatedOutline/Sprite.set_material($Offset/AnimatedOutline/Sprite.get_material().duplicate())
	$Offset/Particles.set_material($Offset/Particles.get_material().duplicate())
	$Offset/AnimatedSprite/Sprite.set_material($Offset/AnimatedSprite/Sprite.get_material().duplicate())
	$Offset/AnimatedSprite/Sprite.set_material($Offset/AnimatedSprite/Sprite.get_material().duplicate())


func set_theme_texture(time_of_day='default'):
	var texture
	if time_of_day == 'default':
		texture = load('res://graphics/sprites/joy/joy' + get_time_of_day().capitalize() + '.png')
		texture_theme = get_time_of_day()
	else:
		texture = load('res://graphics/sprites/joy/joy' + time_of_day.capitalize() + '.png')
		texture_theme = time_of_day
#	$Offset/Outline.texture = texture
	$Offset/AnimatedOutline/Sprite.texture = texture
	$Offset/AnimatedSprite/Sprite.texture = texture

func set_following_player(value):
	is_following_player = value
	if value:
		anim_player.stop(false)
		outline_anim_player.stop(false)
		$Offset/AnimationPlayer2.stop()
		$Offset.position = Vector2.ZERO
		$Offset/Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$Offset/Particles.emitting = true


func set_on_cape(value):
	is_on_cape = value
	if value:
		$Offset/Particles.emitting = false


func _on_Hitbox_area_entered(area):
	PlayerData.score += POINTS_PER_COIN
	$Offset/Hitbox.set_deferred("monitoring", false)
	Events.emit_signal("joy_collected", self.name)
	$SoundEffect.play()
	get_parent().call_deferred("remove_child", self)
	
	$"../../../Player/Cape/Joys".call_deferred("add_child", self)
	if not already_collected:
	#	$"../../../Player/Cape/Joys".cape_size += 1
		globals.cape.append(texture_theme)
	set_following_player(true)
	if self.name.substr(0, 4) == 'Swap':
		Events.emit_signal('swap_layers')


func follow(target_pos, min_dist, max_dist, speed):
	if not is_on_cape: speed /= 3
	var diff = target_pos - position
	var dir = diff.normalized()
	var mag = diff.length()
	position += speed * min(mag - min_dist, 10) * dir
	diff = target_pos - position
	mag = diff.length()
	
	if mag <= max_dist and not is_on_cape:
		if already_collected:
			get_parent().call_deferred("remove_child", self)
			self.queue_free()
		else:
			self.is_on_cape = true
			Events.emit_signal("joy_attached_to_cape")
	
	if mag > max_dist and is_on_cape:
		position += (mag - max_dist) * dir
