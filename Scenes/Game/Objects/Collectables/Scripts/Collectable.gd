extends Node2D

@export_enum('Gem', 'Bubble', 'Moon', 'Checkpoint') var type := 0
@export var amount_increase := 1
@export var score := 10
var started_anim = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if has_node('Anim'):
		get_node('Anim').animation_finished.connect(_on_animation_finished)
	$Area.body_entered.connect(_on_area_body_entered)

func _on_animation_finished(anim):
	if anim == 'collect':
		collect_end()
		
func collect_start():
	Global.score += score
	match type:
		0:
			Global.gem_amount += amount_increase
			Global.Sound.play_sound('Coin', SoundIgnoreType.REPLACE)
		1:
			Global.Game.oxygen_amount += amount_increase
			Global.Sound.play_sound('Bubble', SoundIgnoreType.REPLACE)
		2:
			Global.lifes += amount_increase
			Global.Sound.play_sound('Moon', SoundIgnoreType.REPLACE)
		3:
			Global.start_pos = global_position + Vector2(8,-8)
			Global.Sound.play_sound('Checkpoint', SoundIgnoreType.REPLACE)
			
			
func collect_end():
	get_parent().call_deferred('remove_child', self)

func _on_area_body_entered(body):
	if Global.Game != null:
		if body == Global.Game.Player:
			if !started_anim:
				started_anim = true
				collect_start()
			if !has_node('Anim'):
				collect_end()
			else:
				get_node('Anim').play('collect')
