extends "../motion.gd"

export var ON_GROUND_ACCELERATION = 5

func enter():
	owner.can_dash = true

func update(delta):
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	if owner.velocity.x != 0:
		set_looking_right(owner.velocity.x > 0)
	if not owner.move_and_collide(Vector2.DOWN): # walked off ledge
		emit_signal("finished", "fall")


func handle_input(event):
	if event.is_action_pressed("up"):
		emit_signal("finished", "jump")
	elif event.is_action_pressed("wall") and is_near_wall():
		print(get_wall_state())
		emit_signal("finished", get_wall_state())