extends Node

signal score_changed(new_score)

onready var score = 0

func update_score(new_score):
	score = new_score
	emit_signal("score_changed", new_score)