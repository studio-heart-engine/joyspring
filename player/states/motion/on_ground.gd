extends "../motion.gd"

export var ON_GROUND_ACCELERATION = 7

func enter():
	owner.can_dash = true
	owner.can_wall_climb = true
#	on_wall_timer.stop()
	if owner.previous_state == "fall":
		squish_stretch_player.play("squish")
	
	if owner.has_node("Cape"):
		var cape_joys = owner.get_node("Cape/Joys")
#		if cape_joys.get_child_count() < cape_joys.cape_size:
		if cape_joys.get_child_count() < len(globals.cape):
			Events.emit_signal("begin_cape_regrow")

func update(delta):
	owner.velocity = owner.move_and_slide_with_snap(owner.velocity, Vector2.DOWN * 4, Vector2.UP,
			true, 4, 0.785398, false)
#	push_bodies()
	
	if owner.velocity.x != 0:
		owner.is_looking_right = owner.velocity.x > 0
	
	if not owner.move_and_collide(Vector2.DOWN): # walked off ledge
		emit_signal("finished", "fall")
	elif Input.is_action_pressed("wall") and is_near_wall():
		if owner.get_parent().climb_enabled:
#			on_wall_timer.start()
			owner.can_wall_climb = true
			emit_signal("finished", get_wall_state())


func handle_input(event):
	.handle_input(event)
	if event.is_action_pressed("jump"):
		emit_signal("finished", "jump")
	if event.is_action_pressed('dash') and owner.can_dash and self.input_direction != Vector2.ZERO and $"../../..".dash_enabled:
		emit_signal('finished', 'fall')  # So dash goes to fall after it's complete in case they dash from ground to air
		emit_signal('finished', 'dash')
