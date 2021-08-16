extends "../motion.gd"

export var GRAVITY = 12
export var MAX_IN_AIR_SPEED = 80
export var IN_AIR_ACCELERATION = 6
export var TERMINAL_VELOCITY = 250


func enter():
	
	# from coming off wall
#	on_wall_timer.stop()
#	on_wall_timer.paused = true
	blink_anim_player.stop()
	player_sprite.visible = true
	if cape != null:
		cape.visible = true
	
	owner.velocity.x = clamp(owner.velocity.x, -MAX_IN_AIR_SPEED, MAX_IN_AIR_SPEED)


func reenter():
	owner.velocity.x = clamp(owner.velocity.x, -MAX_IN_AIR_SPEED, MAX_IN_AIR_SPEED)


func update(delta):
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP, 
			false, 4, 0.785398, false)
	push_bodies()
	
	if owner.velocity.x != 0:
		owner.is_looking_right = owner.velocity.x > 0
	
	if owner.is_on_floor():
		spawn_fall_particles()
		owner.can_dash = true
		var next_state = ""
		if Input.is_action_pressed("jump"):
			next_state = "jump"
		elif owner.velocity.x == 0:
			next_state = "idle"
		else:
			next_state = "run"
		emit_signal("finished", next_state)
	elif Input.is_action_pressed("wall") and is_near_wall():
		if owner.get_parent().climb_enabled:
#			on_wall_timer.start()
			owner.can_wall_climb = true
			emit_signal("finished", 'cling')
#			emit_signal("finished", get_wall_state())
	
	.update(delta)


func handle_input(event):
	.handle_input(event)
	if event.is_action_pressed('dash') and owner.can_dash and self.input_direction != Vector2.ZERO and $"../../..".dash_enabled:
		emit_signal('finished', 'dash')
	elif event.is_action_pressed('float') and not owner.can_dash:
		emit_signal('finished', 'float')
