extends "../motion.gd"

export var GRAVITY = 12
export var MAX_IN_AIR_SPEED = 80
export var IN_AIR_ACCELERATION = 4


func enter():
	# from coming off wall
	blink_anim_player.stop()
	player_sprite.visible = true
	
	owner.velocity.x = clamp(owner.velocity.x, -MAX_IN_AIR_SPEED, MAX_IN_AIR_SPEED)


func reenter():
	owner.velocity.x = clamp(owner.velocity.x, -MAX_IN_AIR_SPEED, MAX_IN_AIR_SPEED)


func update(delta):
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	
	if owner.velocity.x != 0:
		set_looking_right(owner.velocity.x > 0)
	
	if owner.is_on_floor():
		spawn_fall_particles()
		var next_state = ""
		if owner.velocity.x == 0:
			next_state = "idle"
		else:
			next_state = "run"
		emit_signal("finished", next_state)
	elif Input.is_action_pressed("wall") and is_near_wall():
		emit_signal("finished", get_wall_state())
	
	.update(delta)


func handle_input(event):
	.handle_input(event)
	if event.is_action_pressed("dash") and owner.can_dash and self.input_direction != Vector2.ZERO:
		emit_signal("finished", "dash")
	elif event.is_action_pressed("glide") and owner.current_state != "glide":
		emit_signal("finished", "glide")