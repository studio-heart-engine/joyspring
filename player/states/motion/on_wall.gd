extends "../motion.gd"

var wall_direction


func _ready():
	on_wall_timer.connect("timeout", self, "on_wall_timer_timeout")


func on_wall_timer_timeout():
	owner.can_wall_climb = false
	emit_signal("finished", "slide")


func enter():
	wall_direction = get_wall_direction()
	set_looking_right(wall_direction == 1)
	owner.velocity = Vector2.ZERO
	if owner.current_state in ["climb", "cling"]:
		if on_wall_timer.is_stopped():
			on_wall_timer.start()
			on_wall_timer.set_paused(false)
		else:
			on_wall_timer.set_paused(false)
	elif on_wall_timer.time_left < 1:
		start_blink()

func exit():
	if owner.current_state in ["climb", "cling"]:
		on_wall_timer.set_paused(true)
	stop_blink()

func update(delta):
	owner.velocity = owner.move_and_slide_with_snap(
			owner.velocity, wall_direction * Vector2.RIGHT, wall_direction * Vector2.LEFT)
	if on_wall_timer.time_left < 1 and not on_wall_timer.is_stopped() and not blink_anim_player.is_playing():
		start_blink()


func handle_input(event):
	.handle_input(event)
	
	# Prevent immediately attaching back onto wall by
	# moving the player 1 pixel away from it
	if self.input_direction.x == -wall_direction:
		owner.move_and_collide(Vector2(-wall_direction, 0))
	
	if event.is_action_released("wall") and owner.current_state != "slide":
		emit_signal("finished", "slide")


func get_wall_direction():
	var original_position = owner.position
	var is_on_right_wall = true if owner.move_and_collide(Vector2.RIGHT) else false
	owner.position = original_position
	return 1 if is_on_right_wall else -1