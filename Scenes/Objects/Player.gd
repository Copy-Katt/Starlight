extends CharacterBody2D

@export var speed = 125.0
@export var run_speed_mult = 1.25
@export var jump_velocity = -120.0

@onready var Sprite = $Sprite
@onready var Collision = $Collision
@onready var CoyoteTime = $CoyoteTime
@onready var Anim = $Anim
@onready var GravityDetect = $GravityDetect

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # 960

var _left_floor = false
var __left_floor = false

# Wether the player can move or not
var can_move = true

# Wether the player has died or not
var died = false

# Right direction relative to the player
var right_direction = Vector2.RIGHT
# Right direction relative to the player at the last frame
var old_right_direction = Vector2.RIGHT

# Velocity without rotation applied
var down_gravity_velocity = Vector2.ZERO
var invert_dir = 1
var old_invert_dir = 1
# Position where the last jump was executed
var last_jump_pos = Vector2.ZERO 
var jump_sound = null
var direction_string = 'r'
var loses_o2 = true
var running = false

func _physics_process(_delta):
	if can_move:
		__left_floor = _left_floor
		_left_floor = is_on_floor()
		
		if _left_floor != __left_floor and _left_floor == false and down_gravity_velocity.y >= 0:
			CoyoteTime.stop()
			CoyoteTime.start()
		
	# Run Handling
		var _run_speed_mult = 1.0
		if Input.is_action_pressed("run"):
			_run_speed_mult = run_speed_mult
		running = Input.is_action_pressed("run")
		
	# Custom Gravity Detector
		up_direction = Vector2.UP
		rotation = 0
		if GravityDetect.get_collider() is GravityArea2D:
			up_direction = -Vector2.from_angle(global_position.angle_to_point(GravityDetect.get_collider().center))
			rotation = up_direction.angle()+PI/2
		old_right_direction = right_direction
		right_direction = Vector2.from_angle(up_direction.angle()+PI/2)
		
	# Handle Jump.
		if Input.is_action_pressed("jump") and (is_on_floor() or (CoyoteTime.time_left > 0 and down_gravity_velocity.y > 0)):
			last_jump_pos = global_position
			down_gravity_velocity.y = jump_velocity
			if jump_sound != null and jump_sound.get_parent() == null or jump_sound == null:
				jump_sound = Global.Sound.play_sound('Jump', SoundIgnoreType.REPLACE)
			$DustParticles.emitting = true
			$DustParticles.restart()
			
	# Add the gravity.
		if not is_on_floor():
			down_gravity_velocity.y += gravity * Global.level_data.gravity_mult * 0.016
			if Input.is_action_pressed("walk_down"):
				down_gravity_velocity.y += 5
		
		old_invert_dir = invert_dir
		
	# Handle Walking
		var direction = Input.get_axis("walk_left", "walk_right")
		if direction:
			invert_dir = old_invert_dir
			down_gravity_velocity.x = move_toward(down_gravity_velocity.x, direction * speed * _run_speed_mult * invert_dir, speed/10)
		else:
			running = false
			invert_dir = round(right_direction.x/2+0.5)*2-1
			down_gravity_velocity.x = move_toward(down_gravity_velocity.x, 0, speed/10)
		
	# Apply Velocity With Custom Gravity
		var _velocity = (down_gravity_velocity.x*right_direction) + (down_gravity_velocity.y*-up_direction)
		velocity = _velocity
			
		move_and_slide()
		
		down_gravity_velocity = velocity.rotated(-old_right_direction.angle())*scale

func _process(_delta):
	if can_move:
		var _run_speed_mult = 1.0
		if Input.is_action_pressed("run"):
			_run_speed_mult = run_speed_mult
		var direction = Input.get_axis("walk_left", "walk_right")
		
		if direction*invert_dir:
			if direction*invert_dir < 0:
				direction_string = 'l'
			elif direction*invert_dir > 0:
				direction_string = 'r'
			if is_on_floor():
				Sprite.play(direction_string+'_walk')
				Sprite.sprite_frames.set_animation_speed(direction_string+'_walk', abs(direction*7*_run_speed_mult))
		else:
			if is_on_floor():
				Sprite.play(direction_string+'_idle')
		
		if !is_on_floor():
			if down_gravity_velocity.y > 0:
				Sprite.play(direction_string+'_fall')
			elif down_gravity_velocity.y < 0:
				Sprite.play(direction_string+'_jump')

		Sprite.scale = Vector2(down_gravity_velocity.y/750+1, -down_gravity_velocity.y/750+1)
		Sprite.skew = down_gravity_velocity.x/500
		$DustParticles.global_position = last_jump_pos
	else:
		Sprite.sprite_frames.set_animation_speed(direction_string+'_walk', 0)
		Sprite.frame = 0
		Sprite.scale = Vector2.ONE

func death():
	if !died:
		died = true
		can_move = false
		Anim.play('death')
		Global.lifes -= 1
		Global.score -= 500
		Global.gem_amount -= 30
		Global.Sound.play_sound('Death', SoundIgnoreType.IGNORE)

func _on_anim_animation_finished(anim_name):
	if anim_name == 'death':
		Global.reset_scene()
