extends CanvasLayer

func update_score_label():
	$MarginContainer/ScoreLabel.text = "Score: " + str(PlayerData.score)