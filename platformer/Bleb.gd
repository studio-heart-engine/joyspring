
tool
extends KinematicBody2D

export var SPEED = 10

enum states {CRAWL, TURN_ACUTE, TURN_OBTUSE, TURN_BACK}

export var facing_right = true setget set_facing_right
var velocity = Vector2(SPEED if facing_right else -SPEED, 0)
var state = states.CRAWL

var possible_colors = [['#c97d54', '#c96254', '#d24b61', '#c9377b'],
					   ['#aee64d', '#83d464', '#57be7c', '#5aa98c'],
					   ['#9583dd', '#967ac9', '#8070be', '#6c6cba']]

onready var down1 = $RayCasts/Down1
onready var down2 = $RayCasts/Down2
onready var forward_bottom = $RayCasts/ForwardBottom
onready var forward_top = $RayCasts/ForwardTop
onready var anim_player = $AnimationPlayer


func set_facing_right(value):
	facing_right = value
	scale.x = 1 if facing_right else -1


func _on_Hitbox_area_entered(area):
	Events.emit_signal("player_died", area.position)
	print('bleb')


func _ready():
	update_image()
	Events.connect('time_of_day_changed', self, 'update_image')
	if not Engine.editor_hint:
		anim_player.play("crawl")
#	$Sprite.material.set_shader_param("outline_color", Color(possible_colors[randi() % len(possible_colors)]))


func _physics_process(delta):
	if Engine.editor_hint:
		return
	match state:
		
		states.CRAWL:
			if not down1.is_colliding():
				if down2.is_colliding():
					anim_player.play("back", -1, 2)
					state = states.TURN_BACK
				else:
					anim_player.play("obtuse-turn", -1, 2)
					state = states.TURN_OBTUSE
			elif forward_bottom.is_colliding():
				if not forward_top.is_colliding():
					anim_player.play("back", -1, 2)
					state = states.TURN_BACK
				else:
					anim_player.play("acute-turn", -1, 2)
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
				
		states.TURN_BACK:
			anim_player.queue("crawl")
			if anim_player.current_animation == "crawl":
				self.facing_right = !self.facing_right
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


var TIME_OF_DAY = ['evening', 'midnight', 'dawn']

func update_image():
	$Sprite.material.set_shader_param("outline_color", Color(possible_colors[globals.time_of_day][randi() % len(possible_colors)]))
	var image_path = "res://graphics/sprites/blobs/" + get_time_of_day() + "/bleb.png"
	$Sprite.set_texture(load(image_path))

func get_time_of_day():
	return TIME_OF_DAY[globals.time_of_day]

#enum TIME_OF_DAY {dawn, evening, midnight}
#
#export (TIME_OF_DAY) var time_of_day = TIME_OF_DAY.evening setget set_time_of_day
#
#func get_time_of_day():
#	return TIME_OF_DAY.keys()[time_of_day]
#
#func set_time_of_day(value):
#	time_of_day = value
#	update_image()
