extends KinematicBody2D

export var speed = 200 # how fast you can run
export var acc = 20 # how fast you can change directions
export var walk_slowness = 0.3
export var gravity = 50
export var jump_height = 20

export (PackedScene) var FallParticles
export (PackedScene) var JumpParticles
export (PackedScene) var AccParticles

onready var velocity = Vector2.ZERO
onready var anim_player = $AnimatedSprite/AnimationPlayer
onready var squish_stretch_player = $AnimatedSprite/SquishStretchPlayer
onready var was_on_floor = is_on_floor()
onready var was_falling = false
onready var is_falling = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if !is_on_floor(): return
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
		var acc_particles = AccParticles.instance()
		acc_particles.position = position
		acc_particles.scale.x = -1 if event.is_action_pressed("ui_right") else 1
		get_parent().add_child(acc_particles)


func _physics_process(delta):
	
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
	
	if dir == 1:
		velocity.x = min(velocity.x + acc, get_move_vel())
		$AnimatedSprite/Sprite.flip_h = false
	elif dir == -1:
		velocity.x = max(velocity.x - acc, -get_move_vel())
		$AnimatedSprite/Sprite.flip_h = true
	elif velocity.x > 0:
		velocity.x -= acc
	elif velocity.x < 0:
		velocity.x += acc
	
	if is_on_floor():
		var anim = ""
		if dir == 0:
			anim = "idle"
		elif Input.is_action_pressed("sneak"):
			anim = "walk"
		else:
			anim = "run"
		anim_player.play(anim)
		
		if !was_on_floor:
			squish_stretch_player.play("squish")
			var fall_particles = FallParticles.instance()
			fall_particles.position = position
			fall_particles.scale.x = -1 if velocity.x < 0 else 1
			get_parent().add_child(fall_particles)
		
		if Input.is_action_pressed("jump"):
			velocity.y = -jump_height * gravity
			squish_stretch_player.play("stretch")
			anim_player.stop()
			anim_player.play("jump")
			var jump_particles = JumpParticles.instance()
			jump_particles.position = position
			get_parent().add_child(jump_particles)
		
	else:
		is_falling = velocity.y > 0
		if is_falling and (!was_falling or was_on_floor):
			anim_player.play("fall")
		was_falling = is_falling
	
	was_on_floor = is_on_floor()
	
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)



func get_move_vel():
	return speed * (walk_slowness if Input.is_action_pressed("sneak") else 1)
	
	
	