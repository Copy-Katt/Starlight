@tool
extends Area2D
class_name GravityArea2D

@export var radius = 100
var center = Vector2.ZERO

func _process(_delta):
	center = global_position
	$Shape.shape.radius = radius
