extends Node2D

# Nodes
@onready var Player = $Player
@onready var Camera = $Camera
var Tiles : TileMap

# O2 Variables
var oxygen_amount := 24.0
var oxygen_mult := 1.0

func _ready():
	# Set Game On Global
	Global.Game = self
	
	Camera.make_current()
	
	Global.load_level('Level1')
	
	# Getting Bounds Of TileMap
	var tile_bounds = Tiles.get_used_rect()
	
	# Camera Startup
	Camera.limit_left = tile_bounds.position.x*16
	Camera.limit_right = (tile_bounds.position.x+tile_bounds.size.x)*16
	
	# Set Limiting Barriers
	$Barriers/Left.position.x = Camera.limit_left
	$Barriers/Right.position.x = Camera.limit_right
	
	Camera.position_smoothing_enabled = false
	for i in 3:
		await get_tree().process_frame
	Camera.position_smoothing_enabled = true
	
	# Set Spawn If Null
#	if Global.start_pos == null:
#		Global.start_pos = 

func _process(_delta):
	# O2 Logic
	if oxygen_amount > 24: oxygen_amount = 24
	elif oxygen_amount < 0: Player.death()
	if Player.running:
		oxygen_mult = 3
	else:
		oxygen_mult = 1
		
	if Player.loses_o2: oxygen_amount -= _delta/2*oxygen_mult
	
	# UI Texts
	$UI/GemCount.text = str(Global.gem_amount)
	$UI/Score.text = Global.fill_num(Global.score, 8)
	$UI/LifesBar.value = Global.lifes
	$UI/O2Bar.value = oxygen_amount
	
	# Camera Positioning
	Camera.position = Player.position+(Player.velocity/10)
	
	# Death By Void
	if Player.position.y > 256: Player.death()
	
func load_level(_level_name):
	if Global.start_pos != Vector2.ZERO:
		Player.global_position = Global.start_pos
	else:
		Player.global_position = Global.level_data.start_pos
	add_child(Global.level_data)
	Tiles = $Level/Tiles
	
