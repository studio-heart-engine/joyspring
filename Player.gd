extends KinematicBody2D

export var speed = 500 # how fast he can run
export var acc = 50 # how fast he can change directions
export var gravity = 50
onready var velocity = Vector2.ZERO

func _physics_process(delta):
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
	
	if dir == 1:
		velocity.x = min(velocity.x + acc, speed)
	elif dir == -1:
		velocity.x = max(velocity.x - acc, -speed)
	elif velocity.x > 0:
		velocity.x -= acc
	elif velocity.x < 0:
		velocity.x += acc
	
	if is_on_floor() and Input.is_action_pressed("ui_up"):
		velocity.y = -20 * gravity
	
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)
	