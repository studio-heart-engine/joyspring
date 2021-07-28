extends Node

signal finished(next_state)

onready var anim_player = owner.get_node("AnimatedSprite/AnimationPlayer")
onready var squish_stretch_player = owner.get_node("AnimatedSprite/SquishStretchPlayer")
onready var blink_anim_player = owner.get_node("AnimatedSprite/BlinkAnimationPlayer")
onready var sound_anim_player = owner.get_node("AnimatedSprite/SoundAnimationPlayer")

onready var player_sprite = owner.get_node("AnimatedSprite")

onready var cape = owner.get_node("Cape")

onready var JumpParticles = preload("res://graphics/particles/JumpParticles.tscn")
onready var FallParticles = preload("res://graphics/particles/FallParticles.tscn")
onready var SkidParticles = preload("res://graphics/particles/SkidParticles.tscn")
onready var DashStartParticles = preload("res://graphics/particles/DashStartParticles.tscn")
onready var DashRingParticles = preload("res://graphics/particles/DashRingParticles.tscn")

onready var on_wall_timer = owner.get_node("OnWallTimer")


func play_anim(anim_name):
	anim_player.play(anim_name)
	if anim_name == "run":
		sound_anim_player.play(anim_name)
	else:
		sound_anim_player.stop()


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
