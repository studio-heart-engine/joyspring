extends Control

onready var level_buttons = $VBoxContainer/LevelButtons.get_children()

func _ready():
	
	for i in range(len(level_buttons)):
		level_buttons[i].text = str(i+1)
		level_buttons[i].connect('pressed', self, 'goto_level', [i+1])


func goto_level(idx):
	SceneChanger.change_scene('platformer/levels/Level_' + '%02d' % idx + '.tscn')
