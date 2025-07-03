class_name Door extends Area2D

@export var destination_level_tag : String
@export var destination_door_tag : String
@export var spawn_direction = "up"
@export var position_door = "UP"

@onready var spawn = $Spawn


func _on_body_entered(body):
	if body is Hero:
		NavigationManager.go_to_level(destination_level_tag, destination_door_tag)
