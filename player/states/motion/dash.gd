extends "../motion.gd"

export var DASH_SPEED = 300
export var MAX_DASH_TIME = 0.2

var direction
var timer

func enter():
	spawn_dash_start_particles()
	camera.shake_camera()
	owner.can_dash = false
	
	var input_direction = get_input_direction()
	direction = input_direction.normalized()
	if input_direction.x != 0:
		set_looking_right(input_direction.x == 1)
	
	anim_player.play("dash")
	anim_player.stop(false)
	if input_direction.x == 0:
		anim_player.advance(0)
	elif input_direction.y == -1:
		anim_player.advance(1)
	elif input_direction.y == 0:
		anim_player.advance(2)
	else:
		anim_player.advance(3)
	
	
	timer = Timer.new()
	timer.set_wait_time(MAX_DASH_TIME)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "finish")
	add_child(timer)
	timer.start()

func exit():
	timer.stop()
	spawn_jump_particles()

func update(delta):
	owner.velocity = direction * DASH_SPEED
	if owner.move_and_collide(owner.velocity * delta):
		finish()

func finish():
	emit_signal("finished", "previous")