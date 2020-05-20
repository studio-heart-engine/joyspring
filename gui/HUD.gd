extends CanvasLayer

func _ready():
	Events.connect("joy_collected", self, "update_score_label")

func update_score_label():
	$MarginContainer/ScoreLabel.text = "Joy: " + str(PlayerData.score)
	$AnimationPlayer.play("joy-label-blink")