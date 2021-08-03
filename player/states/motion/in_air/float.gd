extends "../in_air.gd"

export var MAX_GLIDE_FALL_SPEED = 20
export var GLIDE_FALL_ACCELERATION = 3
export var MAX_GLIDE_HORIZONTAL_SPEED = 90
export var GLIDE_HORIZONTAL_ACCELERATION = 3
export var CAPE_SHRINK_TIME_PER_JOY = 0.1
export var CAPE_REGROW_TIME_PER_JOY = 0.1

onready var cape_shrink_timer = Timer.new()
onready var cape_regrow_timer = Timer.new()
onready var cape_joys

var sound_effects = []

func _ready():
	cape_shrink_timer.connect("timeout", self, "shrink_cape")
	cape_shrink_timer.set_wait_time(CAPE_SHRINK_TIME_PER_JOY)
	cape_regrow_timer.connect("timeout", self, "regrow_cape")
	cape_regrow_timer.set_wait_time(CAPE_REGROW_TIME_PER_JOY)
	
	add_child(cape_shrink_timer)
	add_child(cape_regrow_timer)
	
	if owner.has_node("Cape"):
		cape_joys = owner.get_node("Cape/Joys")
	
	Events.connect("begin_cape_regrow", self, "on_begin_cape_regrow")
	
	for i in range(1, 5):
		sound_effects.append(load('res://music/effects/float' + str(i) + '.wav'))

func on_begin_cape_regrow():
	cape_shrink_timer.stop()
	cape_regrow_timer.start()


func shrink_cape():
	if cape_joys.get_child_count() == 1:
		cape_shrink_timer.stop()
		emit_signal("finished", "fall")
	else:
		cape_joys.get_child(cape_joys.get_child_count()-1).fade_out()


func regrow_cape():
	if not (owner.current_state in ["idle", "run"]):
		cape_regrow_timer.stop()
		return
	
	var n = cape_joys.get_child_count()
#	if n == cape_joys.cape_size:
	if n == len(globals.cape):
		cape_regrow_timer.stop()
	else:
		var joy = load('res://platformer/Joy.tscn').instance()
		cape_joys.add_child(joy)
		joy.position = owner.position
#		if globals.cape[n] != 'normal':
#			joy.set_theme_texture(globals.cape[n])
		joy.set_following_player(true)

#		cape_joys.add_child(cape_joys.get_child(n - 1).duplicate())


func enter():
	# only glide if you have a cape
	if not owner.has_node("Cape") or not $"../../..".float_enabled:
		emit_signal("finished", "previous")
		return
	
	.enter()
	
	Events.emit_signal("float_started")
	play_anim("float")
	$SoundEffect.volume_db = 0
	$SoundEffect.pitch_scale = 1 + rand_range(-0.1, 0.1)
	$SoundEffect.stream = sound_effects[randi() % sound_effects.size()]
	$SoundEffect.play()
	$Timer.start(0.3 + rand_range(0, 1))
#	owner.velocity.y = max(owner.velocity.y, MAX_GLIDE_FALL_SPEED)
	
	cape_shrink_timer.start()


func reenter():
	.reenter()
	enter()
	

func exit():
	Events.emit_signal("float_ended")
	$SoundEffect.stop()
	$Timer.stop()


func update(delta):
	
	if owner.velocity.y > MAX_GLIDE_FALL_SPEED:
		owner.velocity.y = move_smoothly(
				owner.velocity.y, -1, MAX_IN_AIR_SPEED, GLIDE_FALL_ACCELERATION)
	else:
		owner.velocity.y = min(owner.velocity.y + GRAVITY, TERMINAL_VELOCITY)
	
	owner.velocity.x = move_smoothly(
		owner.velocity.x, input_direction.x, MAX_GLIDE_HORIZONTAL_SPEED, GLIDE_HORIZONTAL_ACCELERATION)
	.update(delta)
	if input_direction.x != 0:
		owner.is_looking_right = input_direction.x == 1
	
	var is_slow = owner.velocity.x < MAX_GLIDE_HORIZONTAL_SPEED * 0.9
#	if (anim_player.current_animation == "float") != is_slow:
	if anim_player.current_animation == 'float':
		play_anim("float" if is_slow else "float-move")
	
	if is_near_floor():
		emit_signal("finished", "fall")


func handle_input(event):
	.handle_input(event)
	if event.is_action_pressed('float') and owner.current_state != 'dash':
		emit_signal('finished', 'float')
	elif event.is_action_released('float'):
		emit_signal('finished', 'fall')
#	if event.is_action_pressed("float") and owner.current_state != 'dash':
#		emit_signal("finished", "fall")


func _on_Timer_timeout():
	if not $SoundEffect.is_playing():
		$SoundEffect.volume_db = -15
		$SoundEffect.pitch_scale = 1 + rand_range(-0.1, 0.1)
		$SoundEffect.stream = sound_effects[randi() % sound_effects.size()]
		$SoundEffect.play()
		$Timer.start(0.3 + rand_range(0, 1))
