extends Node


onready var current_song = null
onready var tween = $Tween


func _ready():
	SceneChanger.connect("scene_changed", self, "_on_scene_changed")
	for child in get_children():
		if child is AudioStreamPlayer:
			child.connect("finished", self, "play")


func _on_scene_changed():
	var current_scene = get_tree().get_current_scene()
	var previous_song = current_song
	current_song = $Silence
	if globals.curr_state.substr(0, 5) == 'Level':
		var level_index = int(globals.curr_state.right(5))
	
		if level_index < 14:
			current_song = $ArcTan
		elif level_index == 15:
			current_song = $Silence
		else:
			current_song = $Silence
	elif globals.curr_state == 'Opening' or globals.curr_state == 'Menu':
		pass
	else:
		if current_song != null:
			current_song.stop()
		return
	
	if current_song != previous_song and previous_song != null:
		# fade out
		tween.interpolate_property(
			previous_song, "volume_db", 0, -80, 4,
			Tween.TRANS_LINEAR,Tween.EASE_IN_OUT) 
		tween.start()
		yield(tween, "tween_completed")
		previous_song.stop()
		
		# fade in
		tween.interpolate_property(
			current_song, "volume_db", -30, 0, 6,
			Tween.TRANS_LINEAR,Tween.EASE_IN_OUT) 
		tween.start()
		yield(get_tree().create_timer(0.2), "timeout")
		current_song.play()

	elif not current_song.playing:
		# fade in
		tween.interpolate_property(
			current_song, "volume_db", -30, 0, 6,
			Tween.TRANS_LINEAR,Tween.EASE_IN_OUT) 
		tween.start()
		yield(get_tree().create_timer(0.2), "timeout")
		current_song.play()
