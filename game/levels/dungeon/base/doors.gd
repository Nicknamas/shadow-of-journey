class_name Doors extends RoomElement

const EXIT_NAMES = ["UP", "RIGHT", "DOWN", "LEFT"]

func define(exits: Dictionary) -> void:
	print(exits)
	for exit in self.EXIT_NAMES:
		if exits[exit]:
			print(exit)
			continue
		else:
			var door = get_door_with_position(exit)
			if not door:
				continue
			remove_child(door)
			door.queue_free()


func get_door_with_position(position : String):
	for door in get_children():
		if door.position_door == position:
			return door
	return null
