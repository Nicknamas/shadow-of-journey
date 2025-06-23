class_name Room extends Node

var scene = preload("res://game/levels/room.tscn")

# main | branch | boss | start
@export var type_room : String
@export var init_exit : Vector2i
@export var coords: Vector2i
@export var count_exits : int
@export var exits: Array[Vector2i]


func _init(
		type_room : String,
		init_exit: Vector2i = Vector2i(-1, -1),
		coords : Vector2i = Vector2i(-1, -1)
	) -> void:
	self.init_exit = init_exit
	self.coords = coords
	self.type_room = type_room
	self.count_exits = randi_range(2, 4)
	self._define_exits_for_room()


func init_scene() -> void:
	var instance = scene.instantiate()
	add_child(instance)


func _define_exits_for_room() -> void:
	var exits_variants : Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT]
	exits_variants.erase(init_exit)
	exits.append(init_exit)

	for i in range(1, count_exits):
		var exit = exits_variants[randi_range(0, exits_variants.size() - 1)]
		if exit in exits_variants:
			exits_variants.erase(exit)
			exits.append(exit)
