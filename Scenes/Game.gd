extends Node2D

# Nodes
@onready var Player = $Player
@onready var Camera = $Camera
var Tiles : TileMap

# Level Information
var level_data : Node2D

# O2 Variables
var oxygen_amount := 24.0:
	set(value):
		oxygen_amount = value
		if oxygen_amount > 24: oxygen_amount = 24
		elif oxygen_amount < 0: Player.death()
		$UI/O2Bar.value = oxygen_amount
var oxygen_mult := 1.0

# Camera Limits

var limit_left := -10000000
var limit_right := 10000000

func _ready():
	# Set Game On Global
	Global.Game = self
	
	Camera.make_current()
	
	load_level('Level1')
	
	# Getting Bounds Of TileMap
	var tile_bounds = Tiles.get_used_rect()
	
	# Camera Startup
	limit_left = tile_bounds.position.x*16
	limit_right = (tile_bounds.position.x+tile_bounds.size.x)*16
	
	# Set Limiting Barriers
	$Barriers/Left.position.x = Camera.limit_left
	$Barriers/Right.position.x = Camera.limit_right
	
	Camera.position_smoothing_enabled = false
	for i in 3: await get_tree().process_frame
	Camera.position_smoothing_enabled = true

func _process(_delta):
	if Player.loses_o2: 
		oxygen_amount -= _delta/2*oxygen_mult
	
	# UI Texts
#	if str(Global.gem_amount) != $UI/GemCount.text:
	$UI/GemCount.text = str(Global.gem_amount)
#	if Global.fill_num(Global.score, 8) != $UI/Score.text:
	$UI/Score.text = Global.fill_num(Global.score, 8)
#	if Global.lifes != $UI/LifesBar.value:
	$UI/LifesBar.value = Global.lifes
	
	# Camera Positioning
	Camera.position = Player.position+(Player.velocity/10)
	Camera.rotation = Player.rotation
	
	# Death By Void
	if Player.position.y > 256: Player.death()
	if Player.rotation != 0: 
		Camera.limit_bottom = 10000000
		Camera.limit_left = -10000000
		Camera.limit_right = 10000000
	else:
		Camera.limit_bottom = 240
		Camera.limit_left = limit_left
		Camera.limit_right = limit_right
	
func load_level(_level_name):
	level_data = load("res://Assets/Data/Levels/"+_level_name+".tscn").instantiate()
	if Global.start_pos != Vector2.ZERO:
		Player.global_position = Global.start_pos
	else:
		Player.global_position = level_data.start_pos
	add_child(level_data)
	Tiles = $Level/Tiles
	
