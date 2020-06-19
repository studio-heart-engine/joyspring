extends Node2D

onready var cape_front_anim_player = $CapeFrontOffset/Front/AnimationPlayer
onready var cape_front = $CapeFrontOffset/Front

func _on_AnimationPlayer_animation_started(anim_name):
	cape_front_anim_player.play(anim_name)
