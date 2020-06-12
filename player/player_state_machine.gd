extends KinematicBody2D

var velocity = Vector2.ZERO
var can_dash = true
var can_wall_climb = true
var is_dead = false
var current_state = null
var previous_state = null

onready var sprite = $AnimatedSprite/Sprite

onready var parent_state = $States
onready var states = {
	"idle": $States/Idle,
	"dash": $States/Dash,
	"run": $States/Run,
	"cling": $States/Cling,
	"climb": $States/Climb,
	"slide": $States/Slide,
	"jump": $States/Jump,
	"fall": $States/Fall,
	"glide": $States/Glide,
	"dead": $States/Dead,
}


func _ready():
	for state_node in states.values():
		state_node.connect("finished", self, "change_state")
	
	$AnimatedSprite/Glider.hide()
	
	change_state("idle")


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



func respawn():
	position = $"../PlayerStartPosition".position
	$Camera.align()
	$Camera.reset_smoothing()
	change_state("idle")
	states[current_state].input_direction = Vector2.ZERO
	previous_state = null
	velocity = Vector2.ZERO
	