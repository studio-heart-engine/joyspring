extends "../motion.gd"

var wall_direction
export var INITIAL_WALL_JUMP_SPEED = 50

#func _ready():
#	on_wall_timer.connect("timeout", self, "on_wall_timer_timeout")


#func on_wall_timer_timeout():
#	owner.can_wall_climb = false
#	emit_signal("finished", "slide")


func enter():
	
	if not $"../../..".climb_enabled:
		emit_signal("finished", "previous")

	wall_direction = get_wall_direction()
	owner.is_looking_right = wall_direction == 1
	owner.velocity = Vector2.ZERO

func exit():
	pass
#	stop_blink()

func update(delta):
	owner.velocity = owner.move_and_slide_with_snap(
			owner.velocity, wall_direction * Vector2.RIGHT * 4, wall_direction * Vector2.LEFT,
			false, 4, 0.785398, false)
#	push_bodies()


func handle_input(event):
	.handle_input(event)
	
	# Prevent immediately attaching back onto wall by
	# moving the player 1 pixel away from it
	if self.input_direction.x == -wall_direction:
		owner.move_and_collide(Vector2(-wall_direction, 0))
	if globals.unique_jump and event.is_action_pressed("jump"):
		owner.move_and_collide(Vector2(-wall_direction, 0))
	
	if event.is_action_released("wall") and owner.current_state != "slide":
		emit_signal("finished", "slide")


func get_wall_direction():
	var original_position = owner.position
	var is_on_right_wall = true if owner.move_and_collide(Vector2.RIGHT) else false
	owner.position = original_position
	return 1 if is_on_right_wall else -1
