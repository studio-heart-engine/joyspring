extends KinematicBody2D

var velocity = Vector2.ZERO
var can_dash = true
var can_wall_climb = true
var is_dead = false
var current_state = null
var previous_state = null
var is_looking_right = true setget set_looking_right

onready var sprite = $AnimatedSprite/Sprite

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

func enable_dash(joy_name):
	can_dash = true

func _ready():
	update_image()
	Events.connect('time_of_day_changed', self, 'update_image')
	Events.connect("joy_collected", self, "enable_dash")
	for state_node in states.values():
		state_node.connect("finished", self, "change_state")
	
	change_state("fall")
	
	$AnimatedSprite/Sprite.light_mask = pow(2, 0) + pow(2, 5)


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

func get_time_of_day():
	return TIME_OF_DAY[globals.time_of_day]
