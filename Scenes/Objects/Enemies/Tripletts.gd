extends CharacterBody2D

const SPEED = 50.0
var dir = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * Global.level_data.gravity_mult * delta
		$Sprite.rotation = 0
	else:
		$Sprite.rotation = get_floor_normal().angle()+PI/2
	if is_on_wall():
		dir *= -1
	velocity.x = dir * SPEED
	move_and_slide()
	$Sprite.play(str(dir))

	if Global.Game != null:
		if $Area.overlaps_body(Global.Game.Player):
			Global.Game.Player.death()
