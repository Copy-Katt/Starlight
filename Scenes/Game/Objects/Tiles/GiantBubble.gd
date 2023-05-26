extends Node2D

func _area_entered_exited(body):
	if body == Global.Game.Player:
		Global.Sound.play_sound('Bubble', SoundIgnoreType.REPLACE)

func _process(_delta):
	if $Collision.overlaps_body(Global.Game.Player):
		Global.Game.oxygen_amount += _delta*10
  
