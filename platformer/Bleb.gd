extends KinematicBody2D

export var SPEED = 10

enum states {CRAWL, TURN_ACUTE, TURN_OBTUSE}

export var facing_right = true setget set_facing_right
var velocity = Vector2(SPEED if facing_right else -SPEED, 0)
var state = states.CRAWL

onready var down = $RayCasts/Down
onready var forward = $RayCasts/Forward
onready var anim_player = $AnimationPlayer


func set_facing_right(value):
	facing_right = value
	scale.x = 1 if facing_right else -1
	print("set facing right to " + str(value))


func _on_Hitbox_area_entered(area):
	Events.emit_signal("player_died", area.position)


func _ready():
	anim_player.play("crawl")


func _physics_process(delta):
	
	match state:
		states.CRAWL:
			if not down.is_colliding():
				anim_player.play("obtuse-turn")
				state = states.TURN_OBTUSE
			elif forward.is_colliding():
				anim_player.play("acute-turn")
				state = states.TURN_ACUTE
			else:
				var dir = rotation_degrees + (0 if facing_right else 180)
				dir = deg2rad(dir)
				position += SPEED * Vector2(cos(dir), sin(dir)) * delta
		states.TURN_ACUTE:
			anim_player.queue("crawl")
			if anim_player.current_animation == "crawl":
				turn_acute()
				state = states.CRAWL
		states.TURN_OBTUSE:
			anim_player.queue("crawl")
			if anim_player.current_animation == "crawl":
				turn_obtuse()
				state = states.CRAWL


func turn_acute():
	var coef = 1 if facing_right else -1
	var dir = deg2rad(rotation_degrees)
	position += Vector2(coef * 8, -8).rotated(dir)
	rotation_degrees -= coef * 90


func turn_obtuse():
	var coef = 1 if facing_right else -1
	var dir = deg2rad(rotation_degrees)
	position += Vector2(coef * 8, 8).rotated(dir)
	rotation_degrees += coef * 90
