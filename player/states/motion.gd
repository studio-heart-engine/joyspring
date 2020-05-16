extends "../state.gd"


func get_input_direction():
	var dir = Vector2()
	dir.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	dir.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	return dir


# accelerates or decelerates in one dimension
func move_smoothly(cur_velocity, input_direction, max_speed, acceleration):
	if input_direction == 0:
		# decelerate
		if abs(cur_velocity) < acceleration:
			cur_velocity = 0
		else:
			cur_velocity -= sign(cur_velocity) * acceleration
	else:
		# accelerate
		cur_velocity += input_direction * acceleration
		cur_velocity = clamp(cur_velocity, -max_speed, max_speed)
	
	return cur_velocity


func is_near_wall():
	var original_position = owner.position
	if owner.move_and_collide(Vector2.LEFT):
		return true
	owner.position = original_position
	if owner.move_and_collide(Vector2.RIGHT):
		return true
	owner.position = original_position
	return false


func is_near_floor():
	var original_position = owner.position
	if owner.move_and_collide(Vector2.DOWN):
		return true
	owner.position = original_position
	return false


func get_wall_state():
	var dir = get_input_direction().y
	if dir == -1: return "climb"
	if dir == 0: return "cling"
	if dir == 1: return "slide"
	return null


func spawn_jump_particles():
	var jump_particles = JumpParticles.instance()
	jump_particles.position = owner.position
	owner.get_parent().add_child(jump_particles)


func spawn_fall_particles():
	var fall_particles = FallParticles.instance()
	fall_particles.position = owner.position
	owner.get_parent().add_child(fall_particles)


func spawn_skid_particles():
	var skid_particles = SkidParticles.instance()
	skid_particles.position = owner.position
	skid_particles.scale.x = -get_input_direction().x
	owner.get_parent().add_child(skid_particles)