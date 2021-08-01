extends Node


onready var current_song = null
onready var tween = $Tween

var loop_start = {
	"Silence": 0.0,
	"Awakening": 3.281,
	"Legend": 0.0,
	"Title": 0.0,
	"Mirage": 0.0,
	"TheRiver": 23.396,
	"IntoThinAir": 16.326
}

func _ready():
	SceneChanger.connect("scene_changed", self, "play")
	for child in get_children():
		if child is AudioStreamPlayer:
			child.connect("finished", self, "play")
	play()


func play(song=""):
	if globals.curr_state == 'Menu' and \
	   current_song.get_playback_position() > 50.0 and \
	   current_song.is_playing():
		return  # Don't cut off last chord in opening
	var current_scene = get_tree().get_current_scene()
	var previous_song = current_song
	current_song = $Silence

	if globals.curr_state == 'LevelSelect':
		current_song = $Title
	elif globals.curr_state == 'LevelTemplate':
		current_song = $TheRiver
	elif globals.curr_state.substr(0, 5) == 'Level':
		var level_index = int(globals.curr_state.right(5))
		if level_index < 7:
			current_song = $IntoThinAir
		elif level_index < 12:
			current_song = $Mirage
		elif level_index == 12:
			current_song = $Silence
		elif level_index < 30:
			current_song = $Awakening
		elif level_index < 50:
			current_song = $TheRiver
		else:
			current_song = $Silence
	elif globals.curr_state == 'Legend-Opening':
		current_song = $Legend
	elif globals.curr_state == 'Legend-Ending':
		current_song = $Joyspring
	elif globals.curr_state == 'Menu':
		current_song = $Title
	elif globals.curr_state == 'Temp_End':
		current_song = $Title
	else:
		if current_song != null:
			current_song.stop()
		return
	
	if current_song != previous_song and previous_song != null:
		# fade out
		tween.interpolate_property(
			previous_song, "volume_db", -20, -80, 2,
			Tween.TRANS_LINEAR,Tween.EASE_IN_OUT) 
		tween.start()
		previous_song.stop()
		
		# fade in
		tween.interpolate_property(
			current_song, "volume_db", -30, -20, 2,
			Tween.TRANS_LINEAR,Tween.EASE_IN_OUT) 
		tween.start()
		current_song.play(70)

	elif not current_song.playing:
		if loop_start[current_song.get_name()] == 0.0:
			# fade in
			tween.interpolate_property(
				current_song, "volume_db", -30, -20, 2,
				Tween.TRANS_LINEAR,Tween.EASE_IN_OUT) 
			tween.start()
		current_song.play(loop_start[current_song.get_name()])
