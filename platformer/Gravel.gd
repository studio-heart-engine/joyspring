
tool
extends StaticBody2D

onready var anim_player = $AnimationPlayer
onready var anim_player2 = $AnimationPlayer2

var gravel_sound_effects = []

func _ready():
	update_image()
	Events.connect('time_of_day_changed', self, 'update_image')
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	
	$Sprite.material = $Sprite.material.duplicate()
	
	for i in range(1, 4):
		gravel_sound_effects.append(load('res://music/effects/gravel_' + str(i) + '.wav'))
	
	if self.get_parent().get_parent().get_name() == 'Layer0':
		$TopArea.collision_layer = pow(2, 3)
		$TopArea.collision_mask = pow(2, 0)
		
		$"weak-rock-outline".light_mask = pow(2, 0)
		$Sprite.light_mask = pow(2, 0)
	if self.get_parent().get_parent().get_name() == 'Layer1':
		$TopArea.collision_layer = pow(2, 8)
		$TopArea.collision_mask = pow(2, 5)
		
		$"weak-rock-outline".light_mask = pow(2, 5)
		$Sprite.light_mask = pow(2, 5)

func _on_Area2D_area_entered(area):
	$TopArea/CollisionShape2D.set_deferred("disabled", true)
	anim_player.play("wiggle")
	yield(anim_player, "animation_finished")
	anim_player.play(["rock1", "rock2"][randi() % 2])
	$SoundEffect.volume_db = -5
	$SoundEffect.stream = gravel_sound_effects[int(rand_range(0, 3))]
	$SoundEffect.play()
	anim_player2.play("shrink-hitbox")
	$"weak-rock-outline".set_visible(true)
	anim_player.get_animation(anim_player.current_animation).set_loop(false)
	yield(anim_player, "animation_finished")
	$Sprite.set_visible(false)
	yield(anim_player2, "animation_finished")
	$CollisionShape2D.set_deferred("disabled", true)

func set_collision(val):
	$TopArea/CollisionShape2D.disabled = (not val)
	$CollisionShape2D.disabled = (not val)

var TIME_OF_DAY = ['Evening', 'Midnight', 'Dawn']

func update_image():
	var image_path = "res://graphics/sprites/gravel/gravel" + get_time_of_day() + ".png"
	$Sprite.set_texture(load(image_path))

func get_time_of_day():
	return TIME_OF_DAY[globals.time_of_day]

#enum TIME_OF_DAY {Dawn, Evening, Midnight}
#
#export (TIME_OF_DAY) var time_of_day = TIME_OF_DAY.Evening setget set_time_of_day
#
#
#func get_time_of_day():
#	return TIME_OF_DAY.keys()[time_of_day]
#
#func set_time_of_day(value):
#	time_of_day = value
#	update_image()
