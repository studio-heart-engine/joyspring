extends Light2D

func _ready():
	Events.connect("joy_attached_to_cape", self, "glow")


func glow():
	if $GlowAnimationPlayer.current_animation != "dash-glow":
		$GlowAnimationPlayer.play("glow")

func _on_Dash_player_dashed():
	$GlowAnimationPlayer.play("dash-glow")
