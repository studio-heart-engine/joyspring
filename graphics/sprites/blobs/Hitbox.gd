extends Area2D


func _on_Hitbox_area_entered(area):
	Events.emit_signal("player_died", area.position)
#	print('blob')
