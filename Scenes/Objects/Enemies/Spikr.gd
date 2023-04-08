extends Node2D

func _ready():
	if (global_position.x+global_position.y-16)/32.0 == floor((global_position.x+global_position.y-16)/32.0):
		$Spikes.material = $Spikes.material.duplicate()
		$Spikes.material.set_shader_parameter('invert_direction', true)

func _process(_delta):
	$Eye/Sprite.rotation = -$Eye.rotation
	if Global.Game != null:
		$Eye.rotation = $Eye.global_position.angle_to_point(Global.Game.Player.position)
		if $Area.overlaps_body(Global.Game.Player):
			Global.Game.Player.death()
