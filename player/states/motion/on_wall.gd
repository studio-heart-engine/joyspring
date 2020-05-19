extends "../motion.gd"

var wall_direction

func enter():
	wall_direction = get_wall_direction()
	set_looking_right(wall_direction == 1)
	owner.velocity = Vector2.ZERO


func update(delta):
	owner.velocity = owner.move_and_slide(
			owner.velocity, Vector2(-wall_direction, 0))


func handle_input(event):
	
	if get_input_direction().x == -wall_direction:
		owner.move_and_collide(Vector2(-wall_direction, 0))
	
	if event.is_action_released("wall"):
		emit_signal("finished", "fall")


func get_wall_direction():
	var original_position = owner.position
	var is_on_right_wall = true if owner.move_and_collide(Vector2.RIGHT) else false
	owner.position = original_position
	return 1 if is_on_right_wall else -1