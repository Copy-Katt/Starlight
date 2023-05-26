extends Node2D

var timer_started = [false,false]
@onready var default_pos = [$Tile1.position,$Tile2.position]
@onready var tiles = [$Tile1, $Tile2]

func _process(_delta):
	for i in tiles:
		var start_timer = i.get_node('StartTimer')
		var end_timer = i.get_node('EndTimer')
		var area = i.get_node('Area')
		var sprite = i.get_node('Sprite')
		
		if area.overlaps_body(Global.Game.Player) and !timer_started[tiles.find(i)] and Global.Game.Player.is_on_floor():
			start_timer.start()
			end_timer.start()
			timer_started[tiles.find(i)] = true
		if timer_started[tiles.find(i)] and end_timer.time_left <= 0:
			timer_started[tiles.find(i)] = false
			i.position = default_pos[tiles.find(i)]
			i.get_node('Collision').disabled = false
			var tween = get_tree().create_tween()
			tween.tween_property(i, "modulate", Color(1,1,1,1), 0.5)
			
		if timer_started[tiles.find(i)]:
			if start_timer.time_left <= 0:
				i.position.y += _delta*30
				sprite.offset = Vector2.ZERO
				sprite.rotation = 0
				i.modulate.a -= _delta
				i.get_node('Collision').disabled = true
			else:
				sprite.offset = Vector2(randf_range(-0.5,0.5),randf_range(-0.5,0.5))
				sprite.rotation = randf_range(-0.2,0.2)
				i.modulate.a = 1
				i.get_node('Collision').disabled = false
