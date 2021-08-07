extends Control

var showed = false

onready var texts = [
	load("res://music/effects/text_1.wav"),
	load("res://music/effects/text_2.wav"),
	load('res://music/effects/text_3.wav')
]

func _ready():
	if self.name.substr(0, 6) == 'Select':
		$Label.text = name.right(6)
		$Label.rect_position = Vector2(0, 0)
		$Label.modulate = Color(1, 1, 1, 0.6)
		$Label/AnimationPlayer.set_assigned_animation('highlight')
	elif self.name.substr(0, 8) == 'Dialogue' or \
		 self.name.substr(0, 8) == 'Tutorial' or \
		 self.name.substr(0, 4) == 'Menu':
		$Label.rect_position = Vector2(0, 20)
		$Label.modulate = Color(1, 1, 1, 0)
		$Label/AnimationPlayer.set_assigned_animation('fade_in')

func play(reverse=false, delay=0.0):
#	if reverse:
#		print(str(showed) + " " + globals.curr_state)
	if not showed and not reverse:
		showed = true
		if delay > 0.0:
			yield(get_tree().create_timer(delay), "timeout")
		$Label/AnimationPlayer.play('fade_in')
		if name.begins_with("Dialogue"):
			$Label/SoundEffect.set_stream(texts[randi() % len(texts)])
			$Label/SoundEffect.play()

	if showed and reverse:
		showed = false
		if delay > 0.0:
			yield(get_tree().create_timer(delay), "timeout")
		$Label/AnimationPlayer.play_backwards('fade_in')
