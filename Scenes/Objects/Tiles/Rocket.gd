extends Node2D

var has_launched = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.Game != null:
		if $Area.overlaps_body(Global.Game.Player):
			Global.Game.Player.visible = false
			Global.Game.Player.can_move = false
			Global.Game.Player.loses_o2 = false
			if !has_launched:
				launch()

func launch():
	has_launched = true
	$Anim.play('launch')
	Global.Sound.play_sound('RocketCharge', SoundIgnoreType.IGNORE)
	await get_tree().create_timer(0.7).timeout
	Global.Sound.play_sound('RocketLaunch', SoundIgnoreType.IGNORE)
