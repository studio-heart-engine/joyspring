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
