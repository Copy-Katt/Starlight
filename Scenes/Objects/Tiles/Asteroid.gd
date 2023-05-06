@tool
extends Node2D

@export var radius = 80:
	set(value):
		$GravityArea2D.radius = value
		radius = value
