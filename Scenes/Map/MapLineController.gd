@tool
extends Node2D

@export var lines : Array[PackedInt32Array]:
	set(value):
		lines = value
		queue_redraw()
# each entry is [node1,node2,is_walkable]

@onready var nodes = $"../Nodes"
@onready var path = $"../../Dot"
@onready var map = $"../.."

func create_dots():
	for line in lines:
		print(line)
		var node1 = nodes.get_child(line[0])
		var node2 = nodes.get_child(line[1])
		for i in 9:
			var dot = path.duplicate()
			dot.start_pos = lerp(node1.start_pos, node2.start_pos, (i+1)*0.1)-Vector2(1,1)
			dot.visible = true
			dot.color = Color('f5ffe8') if line[2] else Color('a3a7c2')
			add_child(dot)

func get_angle(id1, id2):
	return nodes.get_child(id1).position.angle_to_point(nodes.get_child(id2).position)

func get_possible_paths(id):
	var fronts = []
	var backs = []
	var both = []
	for i in lines:
		if i[2]:
			if i[0] == id:
				fronts.append(i[1])
				both.append(i[1])
			if i[1] == id:
				backs.append(i[0])
	both.append_array(backs)
	return {
		"both": both,
		"fronts": fronts,
		"backs": backs
	}

func _draw():
	if Engine.is_editor_hint():
		for i in lines:
			draw_dashed_line($"../Nodes".get_child(i[0]).position, $"../Nodes".get_child(i[1]).position, Color('f5ffe8') if i[2] else Color('a3a7c2'), 2, 2, false)
