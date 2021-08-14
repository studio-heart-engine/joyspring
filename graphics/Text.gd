extends Control

var showed = false
var character = 'Riley'
var note = 0

# Riley notes
# 1 - neutral
# 2 - dejected
# 3 - interested
# 4 - serious

# Spirit notes
# 1 - neutral
# 2 - surprised
# 3 - serious
# 4 - reassuring

var voices = {'Riley': ['placeholder'], 'Spirit': ['placeholder']}

func _ready():
	for i in range(1, 5):
		voices['Riley'].append(load('res://music/effects/Kalim-' + str(i) + '.wav'))
		voices['Spirit'].append(load('res://music/effects/Harp-' + str(i) + '.wav'))

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
			if character == 'Riley':
				$Label/SoundEffect.volume_db = -10
			elif character == 'Spirit':
				$Label/SoundEffect.volume_db = 5
			$Label/SoundEffect.set_stream(voices[character][note])
			$Label/SoundEffect.play()

	if showed and reverse:
		showed = false
		if delay > 0.0:
			yield(get_tree().create_timer(delay), "timeout")
		$Label/AnimationPlayer.play_backwards('fade_in')
