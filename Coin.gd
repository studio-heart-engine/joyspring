extends Area2D

func _on_Coin_area_entered(area):
	PlayerData.score += 10
	Events.emit_signal("coin_collected")
	$AnimationPlayer.play("collect")
	$CollisionShape2D.queue_free()
	yield($AnimationPlayer,"animation_finished")
	queue_free()