extends "../on_wall.gd"

export var WALL_SLIDE_SPEED = 40
var particles_instance
onready var wall_slide_particles = preload('res://graphics/particles/WallSlideParticles.tscn')

func enter():
	.enter()
	blink_anim_player.stop()
#	on_wall_timer.stop()
#	on_wall_timer.paused = true
	player_sprite.visible = true
	if cape != null:
		cape.visible = true
	owner.velocity.y = WALL_SLIDE_SPEED
	print('play')
	$SoundEffect.play(rand_range(0, 15))
	play_anim("slide")
	particles_instance = wall_slide_particles.instance()
	player_sprite.add_child(particles_instance)
	particles_instance.scale.x = 1 if owner.is_looking_right else -1


func exit():
	.exit()
	print('stop')
	$SoundEffect.stop()
	particles_instance.queue_free()


func update(delta):
	.update(delta)
	if not is_near_wall():
		emit_signal("finished", "fall")
	elif is_near_floor():
		emit_signal("finished", "idle")


func handle_input(event):
	.handle_input(event)
	
	if self.input_direction.y == 0:
		emit_signal("finished", get_wall_state())
	if globals.unique_jump and event.is_action_pressed("jump"):
		owner.velocity.x = -wall_direction * INITIAL_WALL_JUMP_SPEED
		emit_signal("finished", "jump")
	if self.input_direction.y == -1 and owner.can_wall_climb:
		if owner.get_parent().climb_enabled:
			emit_signal("finished", "climb")
	if self.input_direction.x == -wall_direction:
		emit_signal("finished", "fall")
