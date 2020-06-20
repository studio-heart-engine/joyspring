extends "../motion.gd"

export var ON_GROUND_ACCELERATION = 7

func enter():
	owner.can_dash = true
	owner.can_wall_climb = true
	on_wall_timer.stop()
	if owner.previous_state == "fall":
		squish_stretch_player.play("squish")

func update(delta):
	owner.velocity = owner.move_and_slide_with_snap(owner.velocity, Vector2.DOWN * 4, Vector2.UP)
	
	if owner.velocity.x != 0:
		owner.is_looking_right = owner.velocity.x > 0
	
	if not owner.move_and_collide(Vector2.DOWN): # walked off ledge
		emit_signal("finished", "fall")
	elif Input.is_action_pressed("wall") and is_near_wall():
		emit_signal("finished", get_wall_state())


func handle_input(event):
	.handle_input(event)
	if event.is_action_pressed("up"):
		emit_signal("finished", "jump")