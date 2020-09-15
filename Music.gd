extends Node


onready var current_song = null


func _ready():
	SceneChanger.connect("scene_changed", self, "_on_scene_changed")


func _on_scene_changed():
	var current_scene = get_tree().get_current_scene()
	if not current_scene.has_method("get_level_index"):
		if current_song != null:
			current_song.stop()
		return
	
	var level_index = current_scene.level_index
	
	var previous_song = current_song
	
	if level_index < 3:
		current_song = $ArcTan
	elif level_index < 6:
		current_song = $Something
	else:
		current_song = $Sogn
	
	if current_song != previous_song and previous_song != null:
		previous_song.stop()
	
	if not current_song.playing:
		current_song.play()