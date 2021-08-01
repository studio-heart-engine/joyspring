extends Light2D

func _ready():
	Events.connect("joy_attached_to_cape", self, "glow")
	Events.connect("player_dashed", self, "_on_player_dashed")

func glow():
	if $GlowAnimationPlayer.current_animation != "dash-glow":
		$GlowAnimationPlayer.play("glow")

func _on_player_dashed():
	$GlowAnimationPlayer.play("dash-glow")
