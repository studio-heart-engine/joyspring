extends KinematicBody2D

export var speed = 200 # how fast he can run
export var acc = 20 # how fast he can change directions
export var gravity = 50
var Coin = preload("res://Coin.tscn")

onready var velocity = Vector2.ZERO
onready var anim_player = $AnimatedSprite/AnimationPlayer
onready var particle_emitter = $Particles




func _physics_process(delta):
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
	
	particle_emitter.emitting = dir != 0 && is_on_floor()
	anim_player.play("stand" if dir == 0 else "run")
	
	if dir == 1:
		velocity.x = min(velocity.x + acc, speed)
		$AnimatedSprite/Sprite.flip_h = false
	elif dir == -1:
		velocity.x = max(velocity.x - acc, -speed)
		$AnimatedSprite/Sprite.flip_h = true
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
