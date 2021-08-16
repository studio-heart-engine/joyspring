extends Node


onready var current_song = null
onready var tween = $Tween

var loop_start = {
	"Silence": 0.0,
	"Denial": 3.281,
	"Legend": 0.0,
	"Title": 0.0,
	"Mirage": 0.0,
	"TheRiver": 18.394,
	"IntoThinAir": 42.448,  # 16.326
	"Acceptance": 0.3,
	"OutOfThinAir": 42.448,
	"Departure": 0,
	"LostDreams": 0,
	"Joyspring": 0
}

var volumes = {
	"Silence": -20,
	"Denial": -10,
	"Legend": -20,
	"Title": -20,
	"Mirage": -20,
	"TheRiver": -15,
	"IntoThinAir": -15,
	"Joyspring": -10,
	"Acceptance": -10,
	"OutOfThinAir": -15,
	"Departure": -15,
	"LostDreams": -10
}

func _ready():
	SceneChanger.connect("scene_changed", self, "play")
	Events.connect('zoom_out', self, 'play')
	for child in get_children():
		if child is AudioStreamPlayer:
			child.connect("finished", self, "play")
	play()


func play(song=""):
#	if globals.curr_state == 'Menu' and \
#	   current_song.get_playback_position() > 50.0 and \
#	   current_song.is_playing():
#		return  # Don't cut off last chord in opening
	var current_scene = get_tree().get_current_scene()
	var previous_song = current_song
	current_song = $Silence

	if globals.curr_state == 'LevelTemplate':
		current_song = $Departure
	elif globals.curr_state == 'Level_12' and globals.started_peak_zoom:
		current_song = $Denial
	elif globals.curr_state.substr(0, 5) == 'Level':
		var level_index = int(globals.curr_state.right(5))
		if level_index < 8:
			current_song = $Departure
		elif level_index < 12:
			current_song = $IntoThinAir
		elif level_index == 12:
			current_song = $Silence
		elif level_index < 24:
			current_song = $Denial
		elif level_index < 30:
			current_song = $LostDreams
		elif level_index < 35:
			current_song = $Acceptance
		elif level_index < 39:
			current_song = $Mirage
		elif level_index < 42:
			current_song = $OutOfThinAir
		elif level_index < 49:
			current_song = $TheRiver
		elif level_index <= 50:
			current_song = $Joyspring
		else:
			current_song = $Silence
	elif globals.curr_state == 'Legend-Opening':
		current_song = $Legend
	elif globals.curr_state == 'Legend-Ending':
		current_song = $Joyspring
	elif globals.curr_state == 'End':
		current_song = $Joyspring
	elif globals.curr_state == 'EndTransition':
		current_song = $Joyspring
	elif globals.curr_state == 'Temp_End':
		current_song = $Title
	else:
		if current_song != null:
			current_song.stop()
		return

	if current_song != previous_song and previous_song != null:
		# fade out
#		tween.interpolate_property(
#			previous_song, "volume_db", -20, -80, 2,
#			Tween.TRANS_LINEAR,Tween.EASE_IN_OUT) 
		tween.interpolate_property(
			previous_song, "volume_db",
			volumes[previous_song.name], volumes[previous_song.name] - 60,
			2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		tween.start()
		previous_song.stop()
		
		# fade in
#		tween.interpolate_property(
#			current_song, "volume_db", -30, -20, 2,
#			Tween.TRANS_LINEAR,Tween.EASE_IN_OUT) 
		tween.interpolate_property(
			current_song, "volume_db",
			volumes[current_song.name] - 20, volumes[current_song.name],
			2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		tween.start()
		current_song.play()

	elif not current_song.playing:
		if loop_start[current_song.get_name()] == 0.0:
			# fade in
#			tween.interpolate_property(
#				current_song, "volume_db", -30, -20, 2,
#				Tween.TRANS_LINEAR,Tween.EASE_IN_OUT) 
			tween.interpolate_property(
				current_song, "volume_db",
				volumes[current_song.name] - 20, volumes[current_song.name],
				2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
			)
			tween.start()
		current_song.play(loop_start[current_song.get_name()])
