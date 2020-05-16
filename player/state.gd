extends Node

signal finished(next_state)

var is_looking_right = true setget set_looking_right
onready var anim_player = owner.get_node("AnimatedSprite/AnimationPlayer")
onready var player_sprite = owner.get_node("AnimatedSprite/Sprite")
onready var glider = owner.get_node("Glider")
onready var glider_anim_player = glider.get_node("AnimationPlayer")
onready var glider_sprite = glider.get_node("Sprite")
onready var JumpParticles = preload("res://graphics/particles/JumpParticles.tscn")
onready var FallParticles = preload("res://graphics/particles/FallParticles.tscn")
onready var SkidParticles = preload("res://graphics/particles/SkidParticles.tscn")


func _ready():
	glider_anim_player.get_animation("open").set_loop(false)

func play_anim(anim_name):
	anim_player.play(anim_name + ("-d" if owner.can_dash else "-nd"))


func set_looking_right(value):
	is_looking_right = value
	player_sprite.flip_h = not value
	glider.scale.x = 1 if value else -1


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