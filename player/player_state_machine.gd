extends KinematicBody2D

var velocity = Vector2.ZERO
var can_dash = true
var can_wall_climb = true
var is_dead = false
var current_state = null
var previous_state = null
var is_looking_right = true setget set_looking_right

var on_tile = -1

onready var sprite = $AnimatedSprite/Sprite

var grass_sound_effects = []
var pebbles_sound_effects = []
var dirt_sound_effects = []
var rocks_sound_effects = []
var stones_sound_effects = []

var darkness_colors = ["#236060", "#222039", "#a53f1b"]

onready var states = {
	"idle": $States/Idle,
	"dash": $States/Dash,
	"run": $States/Run,
	"slide": $States/Slide,
	"jump": $States/Jump,
	"fall": $States/Fall,
	"float": $States/Float,
	"dead": $States/Dead,
	"cling": $States/Cling,
	"climb": $States/Climb
}

func enable_dashd(joy_name):
	can_dash = true

func _ready():
	update_image()
	Events.connect('time_of_day_changed', self, 'update_image')
	Events.connect("joy_collected", self, "enable_dash")
	for state_node in states.values():
		state_node.connect("finished", self, "change_state")
	
	change_state("fall")
	
	$AnimatedSprite/Sprite.light_mask = pow(2, 0) + pow(2, 5)
	
	for i in range(1, 6):
		grass_sound_effects.append(load('res://music/effects/footstep_grass_' + str(i) + '.wav'))
		pebbles_sound_effects.append(load('res://music/effects/footstep_pebbles_' + str(i) + '.wav'))
		dirt_sound_effects.append(load('res://music/effects/footstep_dirt_' + str(i) + '.wav'))
		rocks_sound_effects.append(load('res://music/effects/footstep_rocks_' + str(i) + '.wav'))
		stones_sound_effects.append(load('res://music/effects/footstep_stones_' + str(i) + '.wav'))

func play_footstep():
	on_tile = self.get_parent().layers[self.get_parent().layer_num].get_collision_tile(Vector2(0, 4))
	$States/Run/SoundEffect.pitch_scale = 1 + rand_range(-0.05, 0.05)
	if on_tile == 1:
		$States/Run/SoundEffect.volume_db = -10
		$States/Run/SoundEffect.stream = dirt_sound_effects[int(rand_range(0, 5))]
	elif on_tile == 3:
		$States/Run/SoundEffect.volume_db = -10
		$States/Run/SoundEffect.stream = grass_sound_effects[int(rand_range(0, 5))]
	elif on_tile == 5:
		$States/Run/SoundEffect.volume_db = -20
		$States/Run/SoundEffect.stream = pebbles_sound_effects[int(rand_range(0, 5))]
	elif on_tile == 7:
		$States/Run/SoundEffect.volume_db = -10
		$States/Run/SoundEffect.stream = rocks_sound_effects[int(rand_range(0, 5))]
	elif on_tile == 9:
		$States/Run/SoundEffect.volume_db = -10
		$States/Run/SoundEffect.stream = stones_sound_effects[int(rand_range(0, 5))]
	else:  # Assume player on gravel, play pebble sound
		$States/Run/SoundEffect.volume_db = -15
		$States/Run/SoundEffect.stream = pebbles_sound_effects[int(rand_range(0, 5))]
	$States/Run/SoundEffect.play()

func play_climb():
	var dir = Vector2(4 if is_looking_right else -4, 0)
	on_tile = self.get_parent().layers[self.get_parent().layer_num].get_collision_tile(dir)
	$States/Climb/SoundEffect.pitch_scale = 1 + rand_range(-0.05, 0.05)
	if on_tile == 1:
		$States/Climb/SoundEffect.volume_db = -10
		$States/Climb/SoundEffect.stream = dirt_sound_effects[int(rand_range(0, 5))]
	elif on_tile == 3:
		$States/Climb/SoundEffect.volume_db = -10
		$States/Climb/SoundEffect.stream = grass_sound_effects[int(rand_range(0, 5))]
	elif on_tile == 5:
		$States/Climb/SoundEffect.volume_db = -20
		$States/Climb/SoundEffect.stream = pebbles_sound_effects[int(rand_range(0, 5))]
	elif on_tile == 7:
		$States/Climb/SoundEffect.volume_db = -10
		$States/Climb/SoundEffect.stream = rocks_sound_effects[int(rand_range(0, 5))]
	elif on_tile == 9:
		$States/Climb/SoundEffect.volume_db = -10
		$States/Climb/SoundEffect.stream = stones_sound_effects[int(rand_range(0, 5))]
	else:  # Assume player on gravel, play pebble sound
		$States/Climb/SoundEffect.volume_db = -15
		$States/Climb/SoundEffect.stream = pebbles_sound_effects[int(rand_range(0, 5))]
	$States/Climb/SoundEffect.play()

func _input(event):
	states[current_state].handle_input(event)

func _physics_process(delta):
	states[current_state].update(delta)

func change_state(next_state):
	if current_state != null:
		states[current_state].exit()

	if next_state == "previous":
		var temp = current_state
		current_state = previous_state
		previous_state = temp
		states[current_state].input_direction = states[previous_state].input_direction
		states[current_state].reenter()
	else:
		previous_state = current_state
		current_state = next_state
		if not previous_state in [null, "dead"] and current_state != "dead":
			states[current_state].input_direction = states[previous_state].input_direction
		states[current_state].enter()

func set_looking_right(value):
	is_looking_right = value
	sprite.scale.x = 1 if value else -1

var TIME_OF_DAY = ['Evening', 'Midnight', 'Dawn']

func update_image():
	var image_path = "res://graphics/sprites/riley/riley" + get_time_of_day() + ".png"
	$AnimatedSprite/Sprite.set_texture(load(image_path))
	$"cave-darkness".modulate = Color(darkness_colors[globals.time_of_day])

func get_time_of_day():
	return TIME_OF_DAY[globals.time_of_day]


func finish():
	pass # Replace with function body.
