class_name RoomConstuctor extends Node

@export var elements : Array[Node]

var is_defined : bool = false

class RoomTileMapElement extends RoomElement:
	pass


func define_room(exits: Dictionary) -> void:
	for element in elements:
		element.define(exits)
	self.is_defined = true
