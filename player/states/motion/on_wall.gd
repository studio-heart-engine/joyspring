extends "../motion.gd"

var wall_direction


func _ready():
	on_wall_timer.connect("timeout", self, "start_slide")


func start_slide():
	blink_anim_player.play("blink")
	yield(get_tree().create_timer(1), "timeout")
	blink_anim_player.stop()
	emit_signal("finished", "slide")


func enter():
	wall_direction = get_wall_direction()
	set_looking_right(wall_direction == 1)
	owner.velocity = Vector2.ZERO
	if on_wall_timer.is_stopped():
		on_wall_timer.start()


func update(delta):
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2(-wall_direction, 0))


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