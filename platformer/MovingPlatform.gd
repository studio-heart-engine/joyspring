extends Node2D

export (float) var LOOP_TIME = 7

func _ready():
	$AnimationPlayer.playback_speed = 1.0 / LOOP_TIME
