extends Node

signal finished(next_state)

var is_looking_right = true setget set_looking_right


onready var anim_player = owner.get_node("AnimatedSprite/AnimationPlayer")
onready var squish_stretch_player = owner.get_node("AnimatedSprite/SquishStretchPlayer")
onready var blink_anim_player = owner.get_node("AnimatedSprite/BlinkAnimationPlayer")

onready var player_sprite = owner.get_node("AnimatedSprite")

onready var glider = owner.get_node("AnimatedSprite/Glider")
onready var glider_anim_player = glider.get_node("AnimationPlayer")
onready var glider_sprite = glider.get_node("Sprite")

onready var JumpParticles = preload("res://graphics/particles/JumpParticles.tscn")
onready var FallParticles = preload("res://graphics/particles/FallParticles.tscn")
onready var SkidParticles = preload("res://graphics/particles/SkidParticles.tscn")
onready var DashStartParticles = preload("res://graphics/particles/DashStartParticles.tscn")
onready var DashRingParticles = preload("res://graphics/particles/DashRingParticles.tscn")

onready var on_wall_timer = owner.get_node("OnWallTimer")


func _ready():
	glider_anim_player.get_animation("open").set_loop(false)


func play_anim(anim_name):
	anim_player.play(anim_name)


func set_looking_right(value):
	is_looking_right = value
	player_sprite.flip_h = not value


func start_blink():
	blink_anim_player.play("blink")

func stop_blink():
	blink_anim_player.stop()


func enter():
	return

func reenter():
	enter()

func exit():
	return

func update(delta):
	return

func handle_input(event):
	return