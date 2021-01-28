extends Control


export var RADIUS = 36

func check_dialogue(level, ids):
	var player = get_node("../ViewportContainer/Viewport/" + level + "/Player")
	for child in get_children():
		if child.get_name().substr(0, 8) != 'Dialogue' and child.get_name().substr(0, 8) != 'Tutorial':
			continue
		var id = child.get_name().right(8)
		if not (child.get_name().substr(0, 1) + id) in ids:  # Only play animation for dialogue in current level
			continue
		var text_pos
		var trigger_pos
		if child.get_name().substr(0, 8) == 'Dialogue':
			text_pos = get_node("../ViewportContainer/Viewport/" + level + "/Text" + id)
			trigger_pos = get_node("../ViewportContainer/Viewport/" + level + "/Text" + id + "/Pos")
		elif child.get_name().substr(0, 8) == 'Tutorial':
			text_pos = get_node("../ViewportContainer/Viewport/" + level + "/Tut" + id)
			trigger_pos = get_node("../ViewportContainer/Viewport/" + level + "/Tut" + id + "/Pos")
		
		if (trigger_pos.position + text_pos.position).distance_to(player.position) <= RADIUS:
			child.play()
			
#		var x1 = child.rect_position.x
#		var y1 = child.rect_position.y
#		var x2 = child.rect_position.x + child.rect_size.x
#		var y2 = child.rect_position.y + child.rect_size.y
#
#		var bound = 48
#		x1 -= bound
#		x2 += bound
#		y1 -= bound
#		y2 += bound
		
#		var player_pos = player.get_global_transform_with_canvas().origin * $'../..'.scaling
#		if (player_pos.x > x1 and player_pos.x < x2) and (player_pos.y > y1 and player_pos.y < y2):
#			child.play()
