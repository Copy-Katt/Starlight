extends Node2D

var rotation_direction = 1

func _ready():
	if (global_position.x+global_position.y-16)/32.0 == floor((global_position.x+global_position.y-16)/32.0):
		rotation_direction = -1
		$Spikes.rotation = PI/4

func _process(_delta):
	$Spikes.rotation += _delta*rotation_direction
	$Eye/Sprite.rotation = -$Eye.rotation
	if Global.Game != null:
		$Eye.rotation = $Eye.global_position.angle_to_point(Global.Game.Player.position)
		if $Area.overlaps_body(Global.Game.Player):
			Global.Game.Player.death()
