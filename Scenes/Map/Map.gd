extends Node2D

@onready var mesh = $"Planet/3D/Mesh"
var node_index = 0
var arrow_index = 1
var tween
@onready var possible_paths = $Paths/Lines.get_possible_paths(0).both

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in $Paths/Nodes.get_children():
		if i is CanvasItem:
			i.start_pos = i.position
	$Paths/Lines.create_dots()
#		elif i is Line2D:
#			i.create_dots()
#			i.point1_x = i.get_point_position(0).x+i.position.x
#			i.point2_x = i.get_point_position(1).x+i.position.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left"):
		if tween and !tween.is_running() or !tween:
			arrow_index = wrap(arrow_index-1, 0, possible_paths.size())
	if Input.is_action_just_pressed("right"):
		if tween and !tween.is_running() or !tween:
			arrow_index = wrap(arrow_index+1, 0, possible_paths.size())
	if Input.is_action_just_pressed("jump"):
		if tween and !tween.is_running() or !tween:
			tween = create_tween().set_parallel(true)
			tween.tween_property($Arrow, "position:y", $Paths/Nodes.get_child(possible_paths[arrow_index]).start_pos.y, 1)
			tween.tween_property(mesh, "rotation_degrees:y", -$Paths/Nodes.get_child(possible_paths[arrow_index]).start_pos.x*0.45+182.5, 1)
			tween.chain().tween_callback(func(): 
				var _ni = node_index
				node_index = possible_paths[arrow_index]
				possible_paths = $Paths/Lines.get_possible_paths(node_index).both
				arrow_index = possible_paths.find(_ni)
				tween.kill()
			)
	
	$Arrow.rotation = lerp($Arrow.rotation, $Paths/Lines.get_angle(node_index, possible_paths[arrow_index]), delta*20)
	$Arrow/Player.global_rotation = 0
	$Arrow/Player.play('{dir}_{anim}'.format({
		"dir": "l" if Vector2.from_angle($Arrow.rotation).x < 0 else "r",
		"anim": "idle" if tween and !tween.is_running() or !tween else "walk"
	}))
#	$Arrow.position.y = lerp($Arrow.position.y, $Map/Nodes.get_child(node_index).position.y, delta*5)
#	mesh.rotation_degrees.y = lerp(mesh.rotation_degrees.y, -$Map/Nodes.get_child(node_index).start_x*0.45+182.5, delta*5)
	
	
#	mesh.rotation_degrees.y = wrapf(mesh.rotation_degrees.y+Input.get_axis("right", "left")*delta*50, 0, 360)
	var iterator = $Paths/Nodes.get_children()
	iterator.append_array($Paths/Lines.get_children())
	for i in iterator:
		var info = get_info_in_globe(i.start_pos)
		i.position = info.pos
		i.z_index = (-10 if info.behind else 0) + i.layer
		
#		if mesh.rotation_degrees.y > 270-i.start_x/400*180 or \
#		mesh.rotation_degrees.y < 90-i.start_x/400*180:
#			i.z_index = -10+i.layer
#		else:
#			i.z_index = 0+i.layer
				
#		if i is Line2D:
#			i.position.x = 0
#
#			i.set_point_position(0, Vector2(\
#				clamp(-sin(mesh.rotation.y+i.point1_x/400*PI)*200+40, -240, 240), \
#				i.get_point_position(0).y))
#
#			i.set_point_position(1, Vector2(\
#				clamp(-sin(mesh.rotation.y+i.point2_x/400*PI)*200+40, -240, 240), \
#				i.get_point_position(1).y))
#
#			if mesh.rotation_degrees.y > 270 or \
#			mesh.rotation_degrees.y < 90:
#				i.z_index = -1
#			else:
#				i.z_index = 0
#
#			if mesh.rotation_degrees.y > 270-i.point1_x/400*180 or \
#			mesh.rotation_degrees.y < 90-i.point1_x/400*180:
#				i.z_index = -1
#			else:
#				i.z_index = 0

func get_info_in_globe(pos : Vector2):
	return {
		"pos": Vector2(-sin(mesh.rotation.y+pos.x/400*PI)*200+40, pos.y),
		"behind": (mesh.rotation_degrees.y > 270-pos.x/400*180 or \
			mesh.rotation_degrees.y < 90-pos.x/400*180)
	}
