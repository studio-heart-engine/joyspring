extends "../motion.gd"

export var GRAVITY = 12
export var MAX_IN_AIR_SPEED = 80
export var IN_AIR_ACCELERATION = 4

func update(delta):
	owner.velocity.x = move_smoothly(
			owner.velocity.x, get_input_direction().x, MAX_IN_AIR_SPEED, IN_AIR_ACCELERATION)
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
	
	.update(delta)


func handle_input(event):
	if event.is_action_pressed("dash") and owner.can_dash and get_input_direction() != Vector2.ZERO:
		emit_signal("finished", "dash")
	elif event.is_action_pressed("wall") and is_near_wall():
		emit_signal("finished", get_wall_state())
	elif event.is_action_pressed("glide") and owner.current_state != "glide":
		emit_signal("finished", "glide")