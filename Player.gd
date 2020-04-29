extends KinematicBody2D

export var speed = 200
export var acc = 20
var x_vel = 0

func _physics_process(delta):
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
	
	if dir == 1:
		x_vel = min(x_vel + acc, speed)
	elif dir == -1:
		x_vel = max(x_vel - acc, -speed)
	elif x_vel > 0:
		x_vel -= acc
	elif x_vel < 0:
		x_vel += acc
	
	print(x_vel)
	
	move_and_slide(x_vel * Vector2.RIGHT, Vector2.UP)