extends KinematicBody2D

export var speed = 200 # how fast you can run
export var acc = 20 # how fast you can change directions
export var walk_slowness = 0.3 # how much slower walking is
export var gravity = 50
export var jump_height = 20 # actually is jump initial velocity
export var dash_distance = 100
export var wall_slide_vel = 100
export var wall_climb_vel = 80
export var wall_climb_time = 2 # seconds

export (PackedScene) var FallParticles
export (PackedScene) var JumpParticles
export (PackedScene) var AccParticles

var was_falling = false
var is_falling = false
var can_dash = false
var wall_climb_time_left = wall_climb_time

onready var velocity = Vector2.ZERO
onready var anim_player = $AnimatedSprite/AnimationPlayer
onready var squish_stretch_player = $AnimatedSprite/SquishStretchPlayer
onready var was_on_floor = is_on_floor()
onready var was_on_wall = is_on_wall()


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if can_dash and event.is_action_pressed("dash"):
		dash()
	
	if is_on_floor() and (event.is_action_pressed("left") or event.is_action_pressed("right")):
		var acc_particles = AccParticles.instance()
		acc_particles.position = position
		acc_particles.scale.x = -1 if event.is_action_pressed("right") else 1
		get_parent().add_child(acc_particles)


func _physics_process(delta):
	
	velocity = move_and_slide(get_velocity(), Vector2.UP)
	
	if is_on_floor():
		
		can_dash = false
		
		anim_player.play(get_on_floor_anim())
		
		if !was_on_floor: # so it just hit the floor
			squish_stretch_player.play("squish")
			var fall_particles = FallParticles.instance()
			fall_particles.position = position
			fall_particles.scale.x = -1 if velocity.x < 0 else 1
			get_parent().add_child(fall_particles)
		
	else:
		
		if was_on_floor: # so it just got off the floor
			can_dash = true
		
		is_falling = velocity.y > 0 and !is_on_wall()
		if is_falling and (!was_falling or was_on_floor or was_on_wall):
			anim_player.play("fall")
		was_falling = is_falling
	
	if Input.is_action_pressed("up"):
		if is_on_floor():
			velocity.y = -jump_height * gravity
			squish_stretch_player.play("stretch")
			anim_player.play("jump")
			var jump_particles = JumpParticles.instance()
			jump_particles.position = position
			get_parent().add_child(jump_particles)
		elif is_on_wall():
			velocity.x = speed if Input.is_action_pressed("left") else -speed
			velocity.y = -jump_height * gravity
			squish_stretch_player.play("stretch")
			anim_player.play("jump")
			move_and_slide(velocity)
	
	was_on_floor = is_on_floor()
	was_on_wall = is_on_wall()

func get_velocity():
	var dir = 0
	if Input.is_action_pressed("right"):
		dir += 1
	if Input.is_action_pressed("left"):
		dir -= 1
	
	if dir == 1:
		velocity.x = min(velocity.x + acc, get_x_speed())
		$AnimatedSprite/Sprite.flip_h = false
	elif dir == -1:
		velocity.x = max(velocity.x - acc, -get_x_speed())
		$AnimatedSprite/Sprite.flip_h = true
	elif velocity.x > 0:
		velocity.x -= min(acc, velocity.x)
	elif velocity.x < 0:
		velocity.x += min(acc, abs(velocity.x))
	
	if is_on_wall():
		anim_player.play("hang")
		velocity.y = wall_slide_vel
	else:
		velocity.y += gravity
	
	return velocity


func get_on_floor_anim():
	var anim = ""
	if velocity.x == 0:
		anim = "idle"
	elif Input.is_action_pressed("down"):
		anim = "walk"
	else:
		anim = "run"
	return anim


func get_x_speed():
	return speed * (walk_slowness if Input.is_action_pressed("sneak") else 1)



func dash():
	var dir = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		dir += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		dir += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		dir += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		dir += Vector2.RIGHT
	
	var delta_pos = dash_distance * dir.normalized()
	var raycast = get_world_2d().direct_space_state.intersect_ray(position, position + delta_pos, [self])
	
	if raycast:
		position = raycast.position
	else:
		position += delta_pos
	
	can_dash = false