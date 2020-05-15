extends CanvasLayer

func _ready():
	Events.connect("coin_collected", self, "update_score_label")

func update_score_label():
	$MarginContainer/ScoreLabel.text = "Joy: " + str(PlayerData.score)