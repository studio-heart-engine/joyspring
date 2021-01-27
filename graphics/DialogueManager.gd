extends Control


export var RADIUS = 128

func check_dialogue(level, ids):
	var player = get_node("../../ViewportContainer/Viewport/" + level + "/Player")
	for child in get_children():
		if not child.get_name().right(8) in ids:  # Only play animation for dialogue in current level
			continue
		if child.get_name().substr(0, 8) != 'Dialogue':
			continue
		var x1 = child.rect_position.x
		var y1 = child.rect_position.y
		var x2 = child.rect_position.x + child.rect_size.x
		var y2 = child.rect_position.y + child.rect_size.y
		
		var bound = 48
		x1 -= bound
		x2 += bound
		y1 -= bound
		y2 += bound
		
		print($'../../ViewportContainer/Viewport/'.get_child(0).get_name())
		var player_pos = player.get_global_transform_with_canvas().origin * $'../..'.scaling
		
		if (player_pos.x > x1 and player_pos.x < x2) and (player_pos.y > y1 and player_pos.y < y2):
			child.play()
