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
var theme_colors = ['e97d54', 'aee64d', '9583dd']

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
	set_theme_texture()
	Events.connect('time_of_day_changed', self, 'set_theme_texture')

	$Offset/AnimatedOutline/Sprite.material = $Offset/AnimatedOutline/Sprite.material.duplicate()
	$Offset/Particles.material = $Offset/Particles.material.duplicate()
	$Offset/AnimatedSprite/Sprite.material = $Offset/AnimatedSprite/Sprite.material.duplicate()
	if self.get_parent().get_parent().get_name() == 'Layer0':
		$Offset/Hitbox.collision_layer = pow(2, 2)
		$Offset/Hitbox.collision_mask = pow(2, 0)
		
		$Offset/AnimatedSprite/Sprite.light_mask = pow(2, 0)
		$Offset/AnimatedOutline/Sprite.light_mask = pow(2, 0)
		$Offset/Light2D.range_item_cull_mask = pow(2, 0)
	if self.get_parent().get_parent().get_name() == 'Layer1':
		$Offset/Hitbox.collision_layer = pow(2, 7)
		$Offset/Hitbox.collision_mask = pow(2, 5)
		
		$Offset/AnimatedSprite/Sprite.light_mask = pow(2, 5)
		$Offset/AnimatedOutline/Sprite.light_mask = pow(2, 5)
		$Offset/Light2D.range_item_cull_mask = pow(2, 5)
	if self.get_parent().get_parent().get_name() == 'Cape':  # On player cape
		$Offset/AnimatedSprite/Sprite.light_mask = pow(2, 0) + pow(2, 5)
		$Offset/AnimatedOutline/Sprite.light_mask = pow(2, 0) + pow(2, 5)
		$Offset/Light2D.range_item_cull_mask = pow(2, 0) + pow(2, 5)
	
	if already_collected or is_following_player:
		hide_light()


func set_theme_texture(time_of_day='default'):
	if self.name.substr(0, 4) != 'Swap':
		return
	var texture
	if time_of_day == 'default':
		texture = load('res://graphics/sprites/joy/joy' + get_time_of_day().capitalize() + '.png')
		texture_theme = get_time_of_day()
		$Offset/Light2D.color = Color(theme_colors[globals.time_of_day])
	else:
		texture = load('res://graphics/sprites/joy/joy' + time_of_day.capitalize() + '.png')
		texture_theme = time_of_day
		$Offset/Light2D.color = Color(theme_colors[TIME_OF_DAY.find(time_of_day)])
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
		hide_light()


func set_on_cape(value):
	var texture = load('res://graphics/sprites/joy/joy.png')
	$Offset/AnimatedOutline/Sprite.texture = texture
	$Offset/AnimatedSprite/Sprite.texture = texture
	is_on_cape = value
	if value:
		$Offset/Particles.emitting = false
		$Offset/Light2D.show()
		$Offset/Light2D.energy = 0.08


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
	
	var player = self.get_parent().get_parent().get_parent()
	if player.get_name() == 'Player':  # CAUSING LAG
		if not player.can_dash:
			$Offset/Light2D.energy = 0
		else:
			$Offset/Light2D.energy = 0.08
		

func hide_light():
	$Offset/Light2D.hide()

func set_collision(val):
	$Offset/Hitbox/CollisionShape2D.disabled = (not val)
