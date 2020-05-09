extends KinematicBody2D


export var speed = 200 # how fast you can run
export var acc = 20 # how fast you can change directions
export var walk_slowness = 0.3 # how much slower walking is
export var air_slowness = 0.8 # how much slower changing direction is midair

export var gravity = 50
export var jump_power = 20 # actually is jump initial velocity

export var dash_distance = 100

export var wall_climb_speed = 120
export var wall_slide_speed = 70
export var wall_time = 3 # seconds


export (PackedScene) var FallParticles
export (PackedScene) var JumpParticles
export (PackedScene) var AccParticles


var jump_vel = -jump_power * gravity
var is_falling = false
var was_falling = is_falling

var is_on_wall = false
var was_on_wall = is_on_wall
var is_wall_climbing = false
var was_wall_climbing = is_wall_climbing
var is_wall_sliding = false
var can_attach_to_wall = true

var wall_time_left = wall_time

var can_dash = false


onready var velocity = Vector2.ZERO
onready var anim_player = $AnimatedSprite/AnimationPlayer
onready var squish_stretch_player = $AnimatedSprite/SquishStretchPlayer
onready var player_sprite = $AnimatedSprite/Sprite
onready var was_on_floor = is_on_floor()


func _input(event):
	
	if can_dash and event.is_action_pressed("dash") and !is_on_wall:
		dash()
	
	if is_on_floor() and (event.is_action_pressed("left") or event.is_action_pressed("right")) and !Input.is_action_pressed("down"):
		var acc_particles = AccParticles.instance()
		acc_particles.position = position
		acc_particles.scale.x = -1 if event.is_action_pressed("right") else 1
		get_parent().add_child(acc_particles)


func _physics_process(delta):
	
	if can_attach_to_wall and Input.is_action_pressed("wall") and is_near_wall():
		snap_to_wall()
		is_wall_climbing = true
		player_sprite.flip_h = is_near_left_wall()
	else:
		is_wall_climbing = false
		
	
	is_on_wall = is_wall_climbing or is_wall_sliding
	
	if is_on_wall:
		snap_to_wall()
		update_wall_velocity()
		velocity = move_and_slide(velocity)
		wall_time_left -= delta
		if wall_time_left <= 0:
			wall_time_left = wall_time
			can_attach_to_wall = false
	elif is_on_floor():
		can_dash = false
		anim_player.play(get_on_floor_anim())
		update_floor_air_velocity()
		velocity = move_and_slide(velocity, Vector2.UP)
	else:
		update_floor_air_velocity()
		velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("up") and is_on_floor() or !is_on_wall and was_on_wall and Input.is_action_pressed("wall") and can_attach_to_wall and velocity.y < 0:
		squish_stretch_player.play("stretch")
		anim_player.play("jump")
		var jump_particles = JumpParticles.instance()
		jump_particles.position = position
		get_parent().add_child(jump_particles)
		velocity.y = jump_vel
		velocity = move_and_slide(velocity)
	
	if is_on_floor() and !was_on_floor and !is_on_wall: # so they just hit the floor
		can_attach_to_wall = true
		wall_time_left = wall_time
		squish_stretch_player.play("squish")
		var fall_particles = FallParticles.instance()
		fall_particles.position = position
		fall_particles.scale.x = -1 if velocity.x < 0 else 1
		get_parent().add_child(fall_particles)
		
	if !is_on_floor() and was_on_floor: # so it just got off the floor
		can_dash = true
	
	is_falling = velocity.y > 0 and !is_on_floor() and !is_on_wall
	if is_falling and !was_falling:
		anim_player.play("fall")
	was_falling = is_falling
	
	was_on_floor = is_on_floor()
	was_on_wall = is_on_wall


func update_floor_air_velocity():
	var dir = get_x_dir()
	
	if dir == 1:
		velocity.x = min(velocity.x + get_x_acc(), get_x_speed())
		player_sprite.flip_h = false
	elif dir == -1:
		velocity.x = max(velocity.x - get_x_acc(), -get_x_speed())
		player_sprite.flip_h = true
	elif velocity.x > 0:
		velocity.x -= min(get_x_acc(), velocity.x)
	elif velocity.x < 0:
		velocity.x += min(get_x_acc(), abs(velocity.x))
	
	velocity.y += gravity


func get_x_speed():
	return speed * (walk_slowness if Input.is_action_pressed("down") else 1)


func get_x_acc():
	return acc * (air_slowness if !is_on_floor() else 1)


func update_wall_velocity():
	
	var xdir = get_x_dir()
	var xdir_relative = xdir * (-1 if is_near_right_wall() else 1) # -1 is towards the wall, 1 is away
	var ydir = get_y_dir()
	
	if is_wall_sliding:
		# sliding down
		velocity.x = 0
		velocity.y = wall_slide_speed
		anim_player.play("slide")
	
	if xdir_relative == 1:
		# wall jump
		velocity.x = xdir * speed
		velocity.y = ydir * -jump_vel
		velocity = move_and_slide(velocity)
		if ydir == -1: anim_player.play("jump")
	
	elif ydir == 0:
		# cling
		velocity.x = 0
		velocity.y = 0
		anim_player.play("hang-tired")
	
	else:
		# climb
		velocity.x = 0
		velocity.y = ydir * wall_climb_speed
		anim_player.play("climb" if ydir == -1 else "slide")


func get_on_floor_anim():
	var anim = ""
	if velocity.x == 0:
		anim = "idle"
	elif Input.is_action_pressed("down"):
		anim = "walk"
	else:
		anim = "run"
	return anim


func dash():
	var dir = Vector2.ZERO
	if Input.is_action_pressed("up"):
		dir += Vector2.UP
	if Input.is_action_pressed("down"):
		dir += Vector2.DOWN
	if Input.is_action_pressed("left"):
		dir += Vector2.LEFT
	if Input.is_action_pressed("right"):
		dir += Vector2.RIGHT
	
	move_and_collide(dash_distance * dir.normalized())
	
	can_dash = false


func snap_to_wall():
	if move_and_collide(Vector2(2, 0)):
		return true
	position.x -= 2
	if move_and_collide(Vector2(-2, 0)):
		return true
	position.x += 2
	return false


func is_near_wall():
	return is_near_left_wall() or is_near_right_wall()

func is_near_left_wall():
	var temp = position
	var ret = move_and_collide(Vector2(-2, 0))
	position = temp
	return true if ret else false

func is_near_right_wall():
	var temp = position
	var ret = move_and_collide(Vector2(2, 0))
	position = temp
	return true if ret else false

func get_x_dir():
	var dir = 0
	if Input.is_action_pressed("left"):
		dir -= 1
	if Input.is_action_pressed("right"):
		dir += 1
	return dir
	
func get_y_dir():
	var dir = 0
	if Input.is_action_pressed("up"):
		dir -= 1
	if Input.is_action_pressed("down"):
		dir += 1
	return dir