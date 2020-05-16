extends KinematicBody2D

var velocity = Vector2.ZERO
var can_dash = true
var current_state = null
var previous_state = null

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
	
	$Glider.hide()
	
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
		states[current_state].reenter()
	else:
		previous_state = current_state
		current_state = next_state
		states[current_state].enter()
	
	print(current_state)