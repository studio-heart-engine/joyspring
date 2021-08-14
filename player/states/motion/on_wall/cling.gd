extends "../on_wall.gd"

func enter():
	play_anim("hang")
	.enter()
	on_wall_timer.paused = false


func update(delta):
	.update(delta)
	if not is_near_wall():
		emit_signal("finished", "fall")
	if on_wall_timer.time_left < 1 and not on_wall_timer.is_stopped() and not blink_anim_player.is_playing():
		start_blink()


func handle_input(event):
	.handle_input(event)

	if self.input_direction.y == -1:
		if owner.get_parent().climb_enabled:
			emit_signal("finished", "climb")
	elif self.input_direction.y == 1:
		if owner.get_parent().climb_enabled:
			emit_signal("finished", "slide")
	if globals.unique_jump and event.is_action_pressed("jump"):
		owner.velocity.x = -wall_direction * INITIAL_WALL_JUMP_SPEED
		emit_signal("finished", "jump")
	if self.input_direction.x == -wall_direction:
		emit_signal("finished", "fall")
	
