extends KinematicBody2D

export var speed = 500 # how fast he can run
export var acc = 50 # how fast he can change directions
export var gravity = 50

onready var velocity = Vector2.ZERO
onready var animated_sprite = $"AnimatedSprite"
onready var particle_emitter = $Particles

func _physics_process(delta):
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
	
	particle_emitter.emitting = dir != 0 && is_on_floor()
	
	if dir == 1:
		velocity.x = min(velocity.x + acc, speed)
		animated_sprite.scale.x = 5
	elif dir == -1:
		velocity.x = max(velocity.x - acc, -speed)
		animated_sprite.scale.x = -5
	elif velocity.x > 0:
		velocity.x -= acc
	elif velocity.x < 0:
		velocity.x += acc
	
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			velocity.y = -20 * gravity
		elif velocity.y > 0:
			particle_emitter.amount = 50;
			yield(get_tree().create_timer(0.2), "timeout");
			particle_emitter.amount = 10;
	
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if particle_emitter.emitting:
		particle_emitter.process_material.initial_velocity = velocity.x / 1.5
	

func _on_Feet_body_entered(body):
	particle_emitter.emitting = true

func _on_Feet_body_exited(body):
	particle_emitter.emitting = false
