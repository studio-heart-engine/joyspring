extends "../motion.gd"

export var DASH_SPEED = 250
export var MAX_DASH_TIME = 0.24
var MAX_UP_DASH_TIME = MAX_DASH_TIME

var direction
var timer

func enter():
	
	Events.emit_signal("player_dashed")
#
	spawn_dash_start_particles()
	owner.can_dash = false
#
	direction = self.input_direction.normalized()

	if self.input_direction.x != 0:
		owner.is_looking_right = self.input_direction.x == 1

	anim_player.stop()
	anim_player.play("dash")
	anim_player.stop(false)
	$SoundEffect.pitch_scale = 1 + rand_range(-0.2, 0.2)
	$SoundEffect.play()
	if self.input_direction.x == 0:
		anim_player.advance(0)
	elif self.input_direction.y == -1:
		anim_player.advance(1)
	elif self.input_direction.y == 0:
		anim_player.advance(2)
	else:
		anim_player.advance(3)
	
	

	$Timer.set_wait_time(MAX_UP_DASH_TIME if direction.y < 0 else MAX_DASH_TIME)
	$Timer.set_one_shot(true)
	$Timer.start()
	
	yield(get_tree().create_timer(0.07), "timeout")
	spawn_dash_ring_particles()

func exit():
	$Timer.stop()

func update(delta):
	owner.velocity = direction * DASH_SPEED
	if owner.move_and_collide(owner.velocity * delta):
		finish()


func handle_input(event):
	.handle_input(event)
	if event.is_action_pressed("float") and not owner.can_dash and $"../../..".float_enabled:
		emit_signal("finished", "float")


func finish():
	owner.velocity.y *= 0.7
	if Input.is_action_pressed('float') and not owner.can_dash and $"../../..".float_enabled:
		emit_signal("finished", "float")
	else:
		emit_signal("finished", "previous")
