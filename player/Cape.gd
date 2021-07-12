extends Node2D

onready var cape_front_anim_player = $CapeFront/AnimatedSprite/AnimationPlayer
onready var cape_front = $CapeFront
onready var player_anim_player = $"../AnimatedSprite/AnimationPlayer"
onready var player_anim_sprite = $"../AnimatedSprite"


func _process(delta):
	cape_front_anim_player.play(player_anim_player.current_animation)
	cape_front.scale = player_anim_sprite.scale
