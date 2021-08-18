extends Position2D

export var RADIUS = 64
onready var player = $"../Player"

var zoomed = false
var triggered = false

func _process(delta):
	if triggered:
		return
	if (not zoomed) and (position.distance_to(player.position) <= RADIUS) and not globals.finished_peak_zoom:
		globals.started_peak_zoom = true
		Events.emit_signal('zoom_out')
		zoomed = true
		$Timer.start()


func _on_Timer_timeout():
	if zoomed:
		Events.emit_signal('zoom_in')
		zoomed = false
		triggered = true
