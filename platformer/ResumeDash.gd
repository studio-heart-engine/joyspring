extends Node


func _on_SlowTime_resumed():
	get_parent().dash_enabled = true