extends "../state.gd"

var input_direction = Vector2.ZERO setget ,get_input_direction

func _ready():
	Events.connect("player_died", self, "on_player_died")


func on_player_died(position):
	emit_signal("finished", "dead")


func handle_input(event):
	input_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	input_direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))


func get_input_direction():
	return input_direction


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


func push_bodies(inertia = 20):
	for i in owner.get_slide_count():
		var collision = owner.get_slide_collision(i)
		if collision.collider.has_method("apply_central_impulse"):
			var dir = -collision.normal.round()
			if dir == Vector2.DOWN:
				continue
			var impulse_vec = dir * inertia
			collision.collider.apply_central_impulse(impulse_vec)


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


func spawn_jump_particles():
	var jump_particles = JumpParticles.instance()
	owner.get_parent().add_child(jump_particles)
	jump_particles.position = owner.position

func spawn_fall_particles():
	var fall_particles = FallParticles.instance()
	owner.get_parent().add_child(fall_particles)
	fall_particles.position = owner.position

func spawn_skid_particles():
	var skid_particles = SkidParticles.instance()
	owner.get_parent().add_child(skid_particles)
	skid_particles.position = owner.position
	skid_particles.scale.x = -input_direction.x

func spawn_dash_start_particles():
	var dash_start_particles = DashStartParticles.instance()
	owner.get_parent().add_child(dash_start_particles)
	dash_start_particles.init(input_direction)
	dash_start_particles.position = owner.position

func spawn_dash_ring_particles():
	var dash_ring_particles = DashRingParticles.instance()
	owner.get_parent().add_child(dash_ring_particles)
	dash_ring_particles.init(input_direction)
	dash_ring_particles.position = owner.position


